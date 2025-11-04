require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "convert_markdown converts markdown to HTML" do
    markdown_text = "**Bold text** and *italic text*"
    result = convert_markdown(markdown_text)

    assert_includes result, "<strong>Bold text</strong>"
    assert_includes result, "<em>italic text</em>"
  end

  test "convert_markdown handles links" do
    markdown_text = "[Link text](https://example.com)"
    result = convert_markdown(markdown_text)

    assert_includes result, '<a href="https://example.com">Link text</a>'
  end

  test "convert_markdown handles headings" do
    markdown_text = "# Heading 1"
    result = convert_markdown(markdown_text)

    assert_includes result, "<h1>Heading 1</h1>"

    markdown_text2 = "## Heading 2"
    result2 = convert_markdown(markdown_text2)

    assert_includes result2, "<h2>Heading 2</h2>"
  end

  test "convert_markdown handles lists" do
    markdown_text = "- Item 1\n- Item 2"
    result = convert_markdown(markdown_text)

    assert_includes result, "<ul>"
    assert_includes result, "<li>Item 1</li>"
    assert_includes result, "<li>Item 2</li>"
  end

  test "convert_markdown returns HTML safe string" do
    markdown_text = "Plain text"
    result = convert_markdown(markdown_text)

    assert result.html_safe?
  end

  test "convert_markdown disables auto_ids" do
    markdown_text = "# Heading"
    result = convert_markdown(markdown_text)

    # Should not include id attribute since auto_ids is false
    assert_not_includes result, 'id='
  end

  test "to_yes_no returns yes for true" do
    I18n.with_locale(:en) do
      assert_equal I18n.t('yes'), to_yes_no(true)
    end
  end

  test "to_yes_no returns no for false" do
    I18n.with_locale(:en) do
      assert_equal I18n.t('no'), to_yes_no(false)
    end
  end

  test "to_yes_no returns no for nil" do
    I18n.with_locale(:en) do
      assert_equal I18n.t('no'), to_yes_no(nil)
    end
  end

  test "user_is_admin? returns true when signed in as admin" do
    admin_user = users(:one)
    admin_user.update!(is_admin: true)

    # Stub the Devise helper methods
    define_singleton_method(:user_signed_in?) { true }
    define_singleton_method(:current_user) { admin_user }

    assert user_is_admin?
  end

  test "user_is_admin? returns false when signed in as non-admin" do
    regular_user = users(:one)
    regular_user.update!(is_admin: false)

    # Stub the Devise helper methods
    define_singleton_method(:user_signed_in?) { true }
    define_singleton_method(:current_user) { regular_user }

    assert_not user_is_admin?
  end

  test "user_is_admin? returns false when not signed in" do
    # Stub the Devise helper methods
    define_singleton_method(:user_signed_in?) { false }

    assert_not user_is_admin?
  end

  test "is_locale_supported? returns true for supported locale" do
    # Assuming :en and :de are supported locales
    assert is_locale_supported?(:en)
  end

  test "is_locale_supported? returns false for unsupported locale" do
    assert_not is_locale_supported?(:unsupported_locale)
  end

  test "is_locale_supported? handles string locales" do
    assert is_locale_supported?('en'.to_sym)
  end
end
