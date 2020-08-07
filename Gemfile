source 'http://rubygems.org'

gem 'rails', '3.2.21'

# these temporary version pins are due to the ruby version 1.9.3 we are still using...
gem 'rack', '1.4.5'
gem 'rack-cache', '1.2'
gem 'rake', '10.1.0'
gem 'thor', '0.18.1'
gem 'public_suffix', '1.3.3'
gem 'nokogiri', '1.6.1'
gem 'ffi', '1.3.1'
gem 'rb-inotify', '0.9.5'

group :development, :test do
    gem 'sqlite3', '~> 1.3.6'
end

group :production do
    gem 'mysql2', '0.3.21'
end

gem 'json'

gem 'therubyracer'

gem 'capybara'

gem 'kramdown', '2.3.0' # our markdown library, see http://kramdown.rubyforge.org/

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.2.6"
  gem 'coffee-rails', "~> 3.2.2"
  gem 'uglifier',     '>= 1.0.3'
end

gem 'jquery-rails'
gem 'active_scaffold'

# use devise for user auth
gem 'devise'

