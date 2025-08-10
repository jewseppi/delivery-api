# config/application.rb
require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"

Bundler.require(*Rails.groups)

module DeliveryApi
  class Application < Rails::Application
    config.load_defaults 8.0
    config.api_only = true
    
    # CORS configuration for Flutter web app
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'  # In production, specify your Flutter app's URL
        resource '*',
          headers: :any,
          methods: [:get, :post, :put, :patch, :delete, :options, :head],
          expose: ['Authorization']
      end
    end
    
    # Time zone
    config.time_zone = 'UTC'
    
    # Active Job adapter
    config.active_job.queue_adapter = :sidekiq
  end
end