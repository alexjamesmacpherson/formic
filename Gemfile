source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
gem 'bootstrap-sass', '3.3.6'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '3.1.11'
gem 'bcrypt-ruby'
# Use Faker to seed database with sample users
gem 'faker', '1.6.6'
# Use Paginate to sort lists into manageable pages
gem 'will_paginate', '3.1.0'
gem 'bootstrap-will_paginate', '0.0.10'
# Use AutoStripAttributes to remove trailing whitespace and squish excessive whitespace in records
gem 'auto_strip_attributes', '~> 2.1'
# CarrierWave for file uploads
gem 'carrierwave', '~> 1.0'
# AWS for cloud storage of images
gem 'fog-aws'
# Image manipulation post-upload (ie. resizing)
gem 'mini_magick', '4.6.0'
# Simple Calendar... does what it says on the tin
gem 'simple_calendar', '~> 2.0'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
  gem 'coffee-script-source', '1.8.0'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
end

group :test do
  gem 'rake'
  gem 'rails-controller-testing'
  # Test coverage reporting and integration with code climate
  gem 'simplecov'
  gem 'codeclimate-test-reporter', '~> 1.0.0'
end

group :production do
  # PostgreSQL database in deployment environment
  gem 'pg', '0.18.4'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
