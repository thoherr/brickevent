require "test_helper"

# The admin backend (Active Scaffold) needs the gem's stylesheets, which are
# not part of the dartsass-built application.css and must be linked by the
# admin layout (regression test for the backend having lost its CSS).
class AdminLayoutTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  ACTIVE_SCAFFOLD_SHEETS = %w[active_scaffold_layout active_scaffold_images active_scaffold_jquery_ui
                              active_scaffold_extensions active_scaffold_colors].freeze

  test "admin pages link the Active Scaffold stylesheets and they resolve" do
    admin = users(:thoherr)
    admin.confirm
    sign_in admin

    get "/admin/events"
    assert_response :success
    assert_select "link[rel=stylesheet][href*=?]", "application"
    ACTIVE_SCAFFOLD_SHEETS.each do |sheet|
      assert_select "link[rel=stylesheet][href*=?]", sheet, count: 1
    end

    hrefs = css_select("link[rel=stylesheet]").map { |l| l["href"] }
    layout = hrefs.find { |h| h.include?("active_scaffold_layout") }
    get layout
    assert_response :success
    assert_match(/\.active-scaffold/, response.body, "layout stylesheet must contain Active Scaffold rules")
  end

  test "frontend pages do not load the Active Scaffold stylesheets" do
    user = users(:one)
    user.confirm
    sign_in user

    get "/events"
    assert_response :success
    assert_select "link[rel=stylesheet][href*=?]", "active_scaffold", count: 0
  end
end
