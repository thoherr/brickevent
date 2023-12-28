source 'http://rubygems.org'

gem 'rails', '~> 7.0.8'
gem 'rails-controller-testing'

gem 'bootsnap'

gem 'webpacker'

# Use Puma as the app server
gem 'puma'

group :development, :test do
    gem 'sqlite3'
    gem 'listen'
end

group :production do
    gem 'mysql2'
end

gem 'json'

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  # see https://github.com/twalpole/apparition/pull/79#issuecomment-901381116
  gem 'apparition', github: 'twalpole/apparition', ref: 'ca86be4d54af835d531dbcd2b86e7b2c77f85f34'
  gem 'selenium-webdriver'
end

gem 'kramdown' # our markdown library, see http://kramdown.rubyforge.org/

gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier'

gem 'jquery-rails'

gem 'active_scaffold', github: 'activescaffold/active_scaffold', ref: '65dbb573340a2ea6d1027668abe13ca30346242b'

# use devise for user auth
gem 'devise'
gem 'devise-i18n'


gem "webrick", "~> 1.8"
