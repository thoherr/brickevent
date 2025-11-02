source 'https://rubygems.org'

gem 'rails', '~> 7.2'
gem 'rails-controller-testing'

gem 'bootsnap'


# Use Puma as the app server
gem 'puma'

group :development, :test do
    gem 'sqlite3'
    gem 'listen'
end

gem 'simplecov', require: false, group: :test

group :production do
    gem 'mysql2'
end

# https://github.com/salsify/goldiloader
gem 'goldiloader'

gem 'json'

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  # see https://github.com/twalpole/apparition/pull/79#issuecomment-901381116
  gem 'apparition', github: 'twalpole/apparition', ref: 'ca86be4d54af835d531dbcd2b86e7b2c77f85f34'
  gem 'selenium-webdriver'
end

gem 'kramdown' # our markdown library, see http://kramdown.rubyforge.org/

gem 'sprockets-rails'
gem 'sassc' # For Sprockets to compile SCSS from gems (e.g., active_scaffold)
gem 'dartsass-rails'
gem 'importmap-rails'
gem 'terser'

gem 'brakeman'
gem 'bundler-audit'

# https://github.com/perfectline/validates_url
gem 'validate_url'

gem 'jquery-rails'

gem 'active_scaffold', github: 'activescaffold/active_scaffold', ref: 'bce7d9bd0309f4fece73982d6a7f660ecd7068d3'

# use devise for user auth
gem 'devise'
gem 'devise-i18n'

gem 'csv'

gem 'rqrcode'
gem 'acts_as_votable'

gem 'prawn'

gem 'rubyzip'

gem 'webrick', '~> 1.8'
