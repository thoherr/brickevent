source 'http://rubygems.org'

gem 'rails', '~> 6.1.3'
gem 'rails-controller-testing'

gem 'bootsnap'

gem 'webpacker'

# Use Puma as the app server
gem 'puma', '~> 5.0'

group :development, :test do
    gem 'sqlite3'
    gem 'listen'
end

group :production do
    gem 'mysql2'
end

gem 'json'

gem 'therubyracer'

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'apparition'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

gem 'kramdown' # our markdown library, see http://kramdown.rubyforge.org/

gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier'

gem 'jquery-rails'

# See https://github.com/activescaffold/active_scaffold/issues/651
# FIXME use officially released version as soon as they support Rails 6
# gem 'active_scaffold'
gem 'active_scaffold', github: 'activescaffold/active_scaffold', branch: 'master'

# use devise for user auth
gem 'devise'

