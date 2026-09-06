require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "full name and sortable name" do
    user = users(:thoherr)
    assert_equal "Thomas Herrmann", user.full_name
    assert_equal "Herrmann, Thomas", user.sortable_name
  end

  test "full name with missing part" do
    user = User.new(given_name: "Marius")
    assert_equal "Marius", user.full_name
    assert_equal "Marius", user.sortable_name
    user = User.new(family_name: "Herrmann")
    assert_equal "Herrmann", user.full_name
    assert_equal "Herrmann", user.sortable_name
    assert_equal "", User.new.full_name
  end

  test "given and family name are required" do
    user = User.new(email: "new@mytestdomain.de", password: "password", password_confirmation: "password",
                    accept_data_storage: true)
    assert_not user.valid?
    assert_includes user.errors[:given_name], "Bitte gib' Deinen Vornamen an."
    assert_includes user.errors[:family_name], "Bitte gib' Deinen Nachnamen an."

    user.given_name = "New"
    user.family_name = "User"
    assert user.valid?, user.errors.full_messages.join(', ')
  end

end
