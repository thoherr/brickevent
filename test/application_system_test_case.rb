require "test_helper"
require 'capybara/apparition'


class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
  driven_by :apparition

  Capybara.server = :webrick
  Capybara.default_max_wait_time = 5 # Capybara default would be 2 seconds
end
