# Gemfile
source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.0'

gem 'rails', '~> 8.0.2'
gem 'pg', '~> 1.1'
gem 'puma', '~> 6.0'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'rack-cors'

# Authentication & Authorization
gem 'jwt'
gem 'bcrypt', '~> 3.1.7'

# Payment Processing
gem 'stripe'

# Background Jobs
gem 'sidekiq'

# API & Serialization
gem 'jsonapi-serializer'

# WebSocket support
gem 'redis', '~> 4.0'

# Image processing
gem 'image_processing', '~> 1.2'

# Validation
gem 'phonelib'

group :development, :test do
  gem 'byebug', platforms: [:mri, :windows]
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'faker'
end

group :development do
  gem 'listen', '~> 3.3'
  gem 'spring'
end