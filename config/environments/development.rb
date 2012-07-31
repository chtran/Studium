Studium::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb
  config.pusher_app_id = '24003'
  config.pusher_key = 'cb9eb0536f6f8194c197'
  config.pusher_secret = '89a3f76eab32dfe86fbe'
  config.facebook_app_id = '153785024745338'
  config.facebook_secret = '30b9f9acce62ed4af09f699a4dafe474'

  #config.pusher_app_id = '22619'
  #config.pusher_key = '9a81f498ef1031e46675'
  #config.pusher_secret = 'c90fd082578b9efe4f69'
  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  config.action_mailer.default_url_options={host: "localhost:3000"}
end
