require 'test_helper'

# Regression tests for the authorization rules: users may only change their
# own registrations; event managers and admins may change those of their
# events. Fixtures: user one owns attendance one (event three), user two owns
# attendance two and manages event three, thoherr is admin.

module AuthorizationTestHelpers
  def sign_in_as(name)
    user = users(name)
    user.confirm
    sign_in user
    user
  end
end

class ExhibitAuthorizationTest < ActionController::TestCase
  include AuthorizationTestHelpers
  tests ExhibitsController

  test "a user cannot add a MOC to someone else's registration" do
    sign_in_as(:one)
    foreign = attendances(:two)

    assert_no_difference -> { foreign.exhibits.count } do
      post :create, params: { exhibit: { attendance_id: foreign.id, name: "Injected", unit_id: units(:one).id } }
    end
    assert_response :forbidden
  end

  test "a user cannot open the new MOC form for someone else's registration" do
    sign_in_as(:one)

    get :new, params: { attendance_id: attendances(:two).id }

    assert_response :forbidden
  end

  test "a user cannot move their MOC to someone else's registration" do
    sign_in_as(:one)
    exhibit = exhibits(:one)

    put :update, params: { id: exhibit.id, exhibit: { attendance_id: attendances(:two).id } }

    assert_response :forbidden
    assert_equal attendances(:one).id, exhibit.reload.attendance_id
  end

  test "an attendee cannot set table, position or collab flags of their MOC" do
    sign_in_as(:one)
    exhibit = exhibits(:one)
    before = exhibit.attributes.slice("platform", "position", "is_installation", "is_collab")

    put :update, params: { id: exhibit.id, exhibit: { name: "Renamed", platform: 99, position: 7, is_installation: true, is_collab: true } }

    exhibit.reload
    assert_equal "Renamed", exhibit.name, "other fields are still saved"
    assert_equal before, exhibit.attributes.slice("platform", "position", "is_installation", "is_collab")
  end

  test "an event manager can set table and position" do
    sign_in_as(:two)
    exhibit = exhibits(:one)

    put :update, params: { id: exhibit.id, exhibit: { platform: 9, position: 3 } }

    exhibit.reload
    assert_equal [9, 3], [exhibit.platform, exhibit.position]
  end

  test "a forbidden request shows the access denied page" do
    sign_in_as(:one)

    get :edit, params: { id: exhibits(:two).id }

    assert_response :forbidden
    assert_select "h1", I18n.t('access_denied_heading')
  end
end

class AttendeeAuthorizationTest < ActionController::TestCase
  include AuthorizationTestHelpers
  tests AttendeesController

  test "a user cannot add an attendee to someone else's registration" do
    sign_in_as(:one)
    foreign = attendances(:two)

    assert_no_difference -> { foreign.attendees.count } do
      post :create, params: { attendee: { attendance_id: foreign.id, attendee_type_id: attendee_types(:one).id, given_name: "Injected" } }
    end
    assert_response :forbidden
  end

  test "a user cannot move an attendee to someone else's registration" do
    sign_in_as(:one)
    attendee = Attendee.create!(attendance: attendances(:one), attendee_type: attendee_types(:one), given_name: "Own")

    put :update, params: { id: attendee.id, attendee: { attendance_id: attendances(:two).id } }

    assert_response :forbidden
    assert_equal attendances(:one).id, attendee.reload.attendance_id
  end
end

class AccommodationAuthorizationTest < ActionController::TestCase
  include AuthorizationTestHelpers
  tests AccommodationsController

  test "a user cannot add a hotel request to someone else's registration" do
    sign_in_as(:one)

    assert_no_difference -> { Accommodation.count } do
      post :create, params: { accommodation: { attendance_id: attendances(:two).id, accommodation_type_id: accommodation_types(:one).id, count: 1 } }
    end
    assert_response :forbidden
  end
end

class AttendanceAuthorizationTest < ActionController::TestCase
  include AuthorizationTestHelpers
  tests AttendancesController

  test "a user registers themselves, never someone else and never pre-approved" do
    user = sign_in_as(:one)
    event = events(:fourty_two)
    Attendance.where(event: event).delete_all

    post :create, params: { attendance: { user_id: users(:two).id, event_id: event.id, is_approved: true } }

    assert_nil Attendance.find_by(user: users(:two), event: event)
    own = Attendance.find_by(user: user, event: event)
    assert own, "the registration is created for the current user"
    assert_not own.is_approved
  end

  test "a user cannot register while registration is closed" do
    sign_in_as(:one)
    event = events(:two)
    assert_not event.registration_open

    assert_no_difference -> { Attendance.count } do
      post :create, params: { attendance: { event_id: event.id } }
    end
    assert_response :forbidden
  end

  test "an event manager can register another user, approved, while registration is closed" do
    manager = sign_in_as(:three)
    event = events(:four)
    EventManager.create!(event: event, user: manager)
    assert_not event.registration_open

    post :create, params: { attendance: { user_id: users(:one).id, event_id: event.id, is_approved: true } }

    registration = Attendance.find_by(user: users(:one), event: event)
    assert registration
    assert registration.is_approved
  end

  test "a user cannot copy MOCs from someone else's registration" do
    sign_in_as(:one)
    own = attendances(:one)

    assert_no_difference -> { own.exhibits.count } do
      post :copy_exhibits, params: { id: own.id, other_attendance_id: attendances(:two).id }
    end
    assert_response :forbidden
  end

  test "a user cannot copy a single MOC of someone else" do
    sign_in_as(:one)
    own = attendances(:one)
    foreign_exhibit = exhibits(:two)
    assert_not_equal users(:one), foreign_exhibit.attendance.user

    assert_no_difference -> { own.exhibits.count } do
      post :add_former_exhibit, params: { id: own.id, former_exhibit_id: foreign_exhibit.id }
    end
    assert_response :forbidden
  end
end

class LocaleHandlingTest < ActionController::TestCase
  tests EventsController

  # I18n.locale is global for the test thread; don't leak English into later tests.
  teardown { I18n.locale = I18n.default_locale }

  test "an unsupported locale falls back to the default instead of failing" do
    get :index, params: { locale: "xx" }

    assert_response :success
    assert_equal I18n.default_locale, I18n.locale
  end

  test "a supported locale in the URL is used" do
    get :index, params: { locale: "en" }

    assert_response :success
    assert_equal :en, I18n.locale
  end

  test "the browser language is used when the URL has none" do
    @request.headers["Accept-Language"] = "en-US,en;q=0.9"

    get :index

    assert_equal :en, I18n.locale
  end
end
