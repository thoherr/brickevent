require 'test_helper'

class AttendancesControllerTest < ActionController::TestCase
  setup do
    user = users(:one)
    user.confirm
    sign_in user
    @attendance = attendances(:one)
  end

  test "should get index" do
    get :index, params: {}
    assert_response :success
    assert_not_nil assigns(:attendances)
  end

  test "should get new" do
    get :new, params: {}
    assert_response :success
  end

  test "should be approvable by admin" do
    @user = users(:thoherr)
    @user.confirm
    sign_in @user
    post :approve, params: { id: @attendance.id }
    assert_redirected_to event_path(@attendance.event)
  end

  test "should be approvable by event manager" do
    @user = users(:two)
    @user.confirm
    sign_in @user
    post :approve, params: { id: @attendance.id }
    assert_redirected_to event_path(@attendance.event)
  end

  test "should approve attendance with JSON format" do
    @user = users(:thoherr)
    @user.confirm
    sign_in @user

    post :approve, params: { id: @attendance.id, format: :json }

    assert_response :ok
    assert_equal 'application/json', response.media_type
  end

  test "should not be approvable by user" do
    assert_raise do
      post :approve, params: { id: @attendance.id }
    end
  end

  test "should create attendance" do
    assert_difference('Attendance.count') do
      @attendance.event = events(:fourty_two)  # avoid to break uniqueness
      post :create, params: { attendance: @attendance.attributes }
    end

    assert_redirected_to attendance_path(assigns(:attendance))
  end

  test "should show attendance" do
    get :show, params: { id: @attendance.to_param }
    assert_response :success
    assert_select "img[src^='data:image']", { count: 0 }, "no QR code of the attendance URL on the page"
  end

  test "should show order link for approved attendee with voucher" do
    admin = users(:thoherr)
    admin.confirm
    sign_in admin

    get :show, params: { id: attendances(:three).to_param }
    assert_response :success
    assert_select "th", text: I18n.t('heading_shop')
    assert_select "th", text: I18n.t('heading_qr_code')
    assert_select "td.ShopCell a[href=?]", attendees(:one).order_link, text: I18n.t('order_link')
    assert_select "small.VoucherCode", count: 0
  end

  test "should show ticket with qr dialog for paid attendee" do
    admin = users(:thoherr)
    admin.confirm
    sign_in admin
    attendance = attendances(:three)

    get :show, params: { id: attendance.to_param }
    assert_response :success
    assert_select "td.ShopCell a[href=?]", attendees(:three).ticket_url, text: I18n.t('ticket_link')
    assert_select "td.ShopCell a.TicketQrLink", count: 0
    assert_select "td.TicketQrCell span.TicketSecret", text: "s3cr3tt1ck3t"
    assert_select "dialog#ticket-qr-103.TicketQrDialog svg"
    assert_select "td.ShopCell a[href=?]", attendees(:three).order_link, count: 0
  end

  test "should show qr code but not the ticket secret to the attendance owner" do
    # user one owns attendance one (event three) and is neither admin nor event manager;
    # move attendee two into that attendance and give it a paid order
    attendees(:two).update_columns(attendance_id: attendances(:one).id, is_approved: true, order_code: "OWN01", order_position_id: 1, order_status: "paid",
                                   ticket_secret: "owner-secret", ticket_url: "https://pretix.example.com/lug1/ev3/ticket/OWN01/1/x/")
    owner = users(:one)
    owner.confirm
    sign_in owner

    get :show, params: { id: attendances(:one).to_param }
    assert_response :success
    assert_select "td.ShopCell a[href=?]", attendees(:two).ticket_url, text: I18n.t('ticket_link')
    assert_select "td.TicketQrCell a.TicketQrLink", text: I18n.t('show_qr_code')
    assert_select "dialog#ticket-qr-102.TicketQrDialog svg"
    assert_select ".TicketSecret", count: 0
    assert_no_match(/owner-secret/, response.body, "the secret must not appear as text")
  end

  test "should hide shop columns while the shop is not enabled and nobody has ordered" do
    admin = users(:thoherr)
    admin.confirm
    sign_in admin
    events(:three).update!(show_order_link: false)
    attendees(:three).update_columns(order_code: nil, order_status: nil, ticket_secret: nil, ticket_url: nil)

    get :show, params: { id: attendances(:three).to_param }
    assert_response :success
    assert_select "th", text: I18n.t('heading_shop'), count: 0
    assert_select "td.ShopCell", count: 0

    # an imported order makes the columns appear even with the order link switched off
    attendees(:three).update_columns(order_code: "ABC12", order_status: "paid", ticket_secret: "s3cr3t", ticket_url: nil)
    get :show, params: { id: attendances(:three).to_param }
    assert_select "th", text: I18n.t('heading_shop'), count: 1
    assert_select "td.TicketQrCell a.TicketQrLink", count: 1
  end

  test "should not show shop column for event without shop" do
    admin = users(:thoherr)
    admin.confirm
    sign_in admin

    get :show, params: { id: attendances(:five).to_param }
    assert_response :success
    assert_select "th", text: I18n.t('heading_shop'), count: 0
  end

  test "should not show attendance if unauthorized" do
    assert_raise do
      get :show, params: { id: attendances(:two).to_param }
    end
  end

  test "should handle failed attendance creation with invalid data" do
    assert_no_difference('Attendance.count') do
      post :create, params: {
        attendance: {
          user_id: nil,  # Required field
          event_id: nil   # Required field
        }
      }
    end
    assert_response :success
    assert_template :new
  end

  test "should return json error on failed create" do
    post :create, params: {
      attendance: {
        user_id: nil,
        event_id: nil
      },
      format: :json
    }
    assert_response :unprocessable_entity
    assert_equal 'application/json', response.media_type
  end

  test "should copy exhibits from another attendance" do
    @user = users(:one)
    @user.confirm
    sign_in @user

    other_attendance = attendances(:two)

    post :copy_exhibits, params: {
      id: @attendance.id,
      other_attendance_id: other_attendance.id
    }

    assert_redirected_to attendances_url
    assert_equal 'Einträge wurden kopiert.', flash[:notice]
  end

  test "should add former exhibit to attendance" do
    @user = users(:one)
    @user.confirm
    sign_in @user

    former_exhibit = exhibits(:one)

    post :add_former_exhibit, params: {
      id: @attendance.id,
      former_exhibit_id: former_exhibit.id
    }

    assert_redirected_to attendances_url
    assert_equal 'Eintrag wurde kopiert.', flash[:notice]
  end

  test "should return json for former exhibits" do
    get :former_exhibits, params: { id: @attendance.id, format: :json }
    assert_response :success
    assert_equal 'application/json', response.media_type
  end
end
