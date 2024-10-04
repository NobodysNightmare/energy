# frozen_string_literal: true

source 'https://rubygems.org'

gem 'haml-rails'
gem 'kaminari'
gem 'mysql2'
gem 'puma', '~> 6.0'
gem 'rails', '~> 7.2.0'
gem 'sassc-rails', '~> 2.0'
gem 'mini_racer'
gem 'uglifier', '>= 1.3.0'

gem 'omniauth', '~> 1.3'
gem 'omniauth-google-oauth2'

gem 'http_accept_language', '~> 2.1'

gem 'jquery-rails'

# Application monitoring
gem 'sentry-raven'

group :development, :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rubocop', require: false
end

group :development do
  gem 'listen', '~> 3.5'
  gem 'rspec-rails', '~> 7.0', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
