require "test_helper"
require 'capybara/apparition'


class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
  driven_by :apparition

  Capybara.server = :webrick
  Capybara.default_max_wait_time = 5 # Capybara default would be 2 seconds

  # Apparition does not report failed module loads, so print what the browser
  # actually loaded when a test fails (helps with failures that only show up in CI).
  # Runs before Rails takes the failure screenshot and resets the session.
  def before_teardown
    print_browser_diagnostics unless passed? || skipped?
    super
  end

  private

  def print_browser_diagnostics
    info = page.evaluate_async_script(<<~JS)
      const done = arguments[0];
      const map = document.querySelector('script[type="importmap"]');
      const imports = map ? JSON.parse(map.textContent).imports : {};
      Promise.all(Object.entries(imports).map(([name, url]) =>
        fetch(url).then(r => `${r.status} ${name} -> ${url}`, e => `ERR ${name} -> ${url}: ${e}`)
      )).then(modules => done({
        userAgent: navigator.userAgent,
        url: location.href,
        turbo: typeof window.Turbo,
        stimulus: typeof window.Stimulus,
        modules: modules
      }));
    JS
    puts "\n--- browser diagnostics for #{name} ---"
    info.each { |key, value| puts "#{key}: #{Array(value).join("\n  ")}" }
    puts "console errors:\n  #{page.driver.error_messages.map(&:to_s).join("\n  ")}"
  rescue StandardError => e
    puts "browser diagnostics failed: #{e.class}: #{e.message}"
  end
end
