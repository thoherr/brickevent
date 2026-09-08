require 'test_helper'

class LugTest < ActiveSupport::TestCase

  test "logo and favicon accept absolute urls and paths or blank" do
    lug = lugs(:lugone)
    assert lug.valid?, lug.errors.full_messages.join(', ')

    lug.favicon_url = "https://cdn.example.com/favicon.ico"
    lug.logo_url = ""
    assert lug.valid?
  end

  test "logo and favicon reject bare file names" do
    lug = lugs(:lugone)
    lug.favicon_url = "bricking-bavaria.favicon.ico"
    lug.logo_url = "logo.png"
    assert_not lug.valid?
    assert lug.errors[:favicon_url].any?
    assert lug.errors[:logo_url].any?
  end

end
