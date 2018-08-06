source 'https://rubygems.org'

gem 'rails', '3.2.22'

group :development, :test, :production do
  gem 'pg'
  gem 'haml-rails', '~> 0.4.0' # Use Haml as default markup language
end

group :production do
  gem 'rails_12factor'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem "sass", "~> 3.2.5"
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

group :development, :test do
  gem 'guard-rspec', '~> 4.6.4' # Automatically run specs
  gem 'rspec-rails', '~> 2.99.0'
end

group :test do
  gem 'cucumber-rails', :require => false
  gem 'cucumber-rails-training-wheels' # Some pre-fabbed step definitions
  gem 'database_cleaner' # To clear Cucumber's test database between runs
  gem 'capybara' # Lets Cucumber pretend to be a web browser
  gem 'launchy'

  gem 'factory_girl_rails', '~> 4.5.0', :require => false # Use instead of fixtures for ActiveRecord objects
  gem 'faker', '~> 1.4.3' # Populate test database with realistic looking test data
  gem 'selenium-webdriver', '~> 2.47.1'

  gem 'simplecov', '~> 0.10.0', :require => false
end

gem 'jquery-rails'
gem 'rails3-jquery-autocomplete'
gem 'jquery-ui-rails'

gem 'custom_error_message', '~> 1.1.1' # Custom model validation messages

ruby '1.9.3' # Specify ruby version for Heroku
