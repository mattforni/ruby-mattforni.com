Mattforni::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true
  config.assets.logger = false
  config.quiet_assets = true

  # Log SQL to STDOUT in development
  # ActiveRecord::Base.logger = Logger.new(STDOUT)

  # Added for devise.
  config.action_mailer.default_url_options = { host: 'localhost:8080' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.smtp_settings = {
    address: 'smtp.gmail.com',
    authentication: 'plain',
    domain: 'gmail.com',
    enable_starttls_auto: true,
    password: 'Cantf33lth3h3at!',
    port: 587,
    user_name: 'matthew.fornaciari@gmail.com'
  }
end

