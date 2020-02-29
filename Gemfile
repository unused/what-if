# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.0'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.4'
# Use Puma as the app server
gem 'puma', '~> 3.12'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'

# Use warden for authentication
gem 'rails_warden', '~> 0.6.0'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Use fuzzy match for choice similarity calculation
gem 'fuzzy_match', '~> 2.1.0'

# Use parselet to parse and interpret twee passages
gem 'parslet', '~> 1.8.2'

# Sidekiq background worker
gem 'sidekiq', '~> 6.0.1'

# Use alexarb for custom skill handling
gem 'alexarb', github: 'unused/alexarb'

group :development, :test do
  # Use test factories
  gem 'factory_bot_rails'
  # Generate fake data for tests and seed development database
  gem 'faker'
  # Use pry as debugger
  gem 'pry'

  # Check for security best practices
  gem 'brakeman'
  # Check for outdated bundles
  gem 'bundle-audit'
  # Check for coding style best practices using rubocop
  gem 'rubocop'
  gem 'rubocop-faker'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Use rspec for tests
  gem 'rspec-rails'
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
  # auto test runs with filewatch
  gem 'guard-rspec'
  # run tests with a clean database
  gem 'database_cleaner'
end
