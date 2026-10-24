require 'test_helper'

# Regression test for config/initializers/monkeypatch/nested_subform_empty_check.rb:
# blank nested subform rows (as the browser submits them) must be ignored, not
# turned into invalid new records.
class AdminSubformTest < ActionController::TestCase
  tests Admin::EventsController

  setup do
    admin = users(:thoherr)
    admin.confirm
    sign_in admin
  end

  test "blank nested event manager row with a nested user form is ignored" do
    event = events(:one)
    manager = event.event_managers.first
    before = EventManager.where(event_id: event.id).pluck(:id, :user_id)

    patch :update, xhr: true, params: {
      id: event.to_param,
      record: {
        name: event.name, title: event.title, description: "BB is the best",
        lug: event.lug_id.to_s, has_afols_event: "1", has_tickets: "1", registration_open: "1",
        event_managers: {
          "0" => "",
          manager.id.to_s => { "id" => manager.id.to_s, "user" => { "id" => manager.user_id.to_s, "email" => manager.user.email,
                                                                     "given_name" => "Thomas", "family_name" => "Herrmann",
                                                                     "is_admin" => "1", "accept_data_storage" => "1" } },
          "1730764800000000" => { "user" => { "email" => "", "given_name" => "", "family_name" => "", "lug" => "", "nickname" => "",
                                              "address" => "", "phone" => "", "is_admin" => "0", "accept_data_storage" => "0" } }
        }
      }
    }

    assert_response :success
    assert_not_includes response.body, "ungültig"
    assert_equal "BB is the best", event.reload.description
    assert_equal before, EventManager.where(event_id: event.id).pluck(:id, :user_id), "no blank event manager must be created"
  end
end
