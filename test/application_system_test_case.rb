require "test_helper"
require 'capybara/apparition'


class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
  driven_by :apparition

  Capybara.server = :webrick
  Capybara.default_max_wait_time = 5 # Capybara default would be 2 seconds

  # Apparition treats a page as loaded as soon as its JavaScript context exists,
  # which can be before the module scripts (Turbo, Stimulus, our handlers) have run.
  # On a slow machine a test then clicks a link before Turbo handles it. Wait until
  # the document is complete, which is only after the module scripts have run.
  module WaitForPageScripts
    def self.wait(session)
      session.document.synchronize(10) do
        next true if session.evaluate_script("document.readyState") == "complete"

        raise Capybara::ExpectationNotMet, "page scripts have not run yet"
      end
    end

    module Session
      def visit(...)
        super.tap { WaitForPageScripts.wait(self) }
      end
    end

    module Element
      def click(...)
        WaitForPageScripts.wait(session)
        super
      end
    end
  end
  Capybara::Session.prepend(WaitForPageScripts::Session)
  Capybara::Node::Element.prepend(WaitForPageScripts::Element)

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
