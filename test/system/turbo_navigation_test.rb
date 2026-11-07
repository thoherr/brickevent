require "application_system_test_case"

# Turbo Drive replaced jquery_ujs on the frontend pages: delete and post links use
# data-turbo-method / data-turbo-confirm, failed forms are re-rendered with 422,
# redirects after a DELETE use 303.
class TurboNavigationTest < ApplicationSystemTestCase
  def login_admin
    visit '/users/sign_in'
    fill_in 'user_email', :with => users(:thoherr).email
    fill_in 'user_password', :with => "test123"
    click_on 'submit'
    assert_selector "#logoutLink"
  end

  test "turbo drive is active on the frontend" do
    visit '/'
    assert page.evaluate_script("typeof window.Turbo === 'object'"), "Turbo should be loaded"
    assert page.evaluate_script("typeof window.jQuery === 'undefined'"), "jQuery is only needed in the admin backend"
  end

  test "deleting a MOC asks for confirmation and returns to the attendance" do
    login_admin
    exhibit = Exhibit.create!(attendance: attendances(:three), name: "MOC to delete", unit: units(:one))
    visit attendance_path(attendances(:three))
    delete_link = "a[data-turbo-method='delete'][href^='#{exhibit_path(exhibit)}?']"

    dismiss_confirm { find(delete_link).click }
    assert_selector delete_link
    assert Exhibit.exists?(exhibit.id), "dismissing the confirmation keeps the MOC"

    accept_confirm { find(delete_link).click }
    assert_no_selector delete_link
    assert_current_path attendance_path(attendances(:three)), ignore_query: true
    assert_not Exhibit.exists?(exhibit.id)
    take_screenshot
  end

  test "a form with invalid input is shown again with the error" do
    login_admin
    exhibit = exhibits(:three)
    visit edit_exhibit_path(exhibit)

    fill_in 'exhibit_url', :with => "ftp://example.com/moc"
    click_on 'submit'

    assert_selector ".field_with_errors #exhibit_url"
    assert_equal "ftp://example.com/moc", find_field('exhibit_url').value
    assert_equal "https://moc3.example.com/", exhibit.reload.url
    take_screenshot
  end

  test "logout works without jquery_ujs" do
    login_admin
    find("#logoutLink a").click

    assert_no_selector "#logoutLink"
    assert_current_path root_path, ignore_query: true
  end

  test "the admin backend is opened with a full page load" do
    login_admin
    click_on "Administration"

    assert_current_path admin_events_path, ignore_query: true
    assert_selector "#admin_events-active-scaffold, .active-scaffold"
    assert page.evaluate_script("typeof window.jQuery === 'function'"), "jQuery is loaded for Active Scaffold"
    assert page.evaluate_script("typeof window.Turbo === 'undefined'"), "the admin page is not rendered into the Turbo frontend document"
  end
end
