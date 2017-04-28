Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :redis_store, {
      host: ENV['REDIS_HOST'] || 'localhost',
      port: ENV['REDIS_PORT'] || 6379,
      db: 0,
      namespace: 'cache',
      expires_in: 1.minute,
    }

    config.public_file_server.headers = {
      'Cache-Control' => 'public, max-age=172800',
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  # config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  # If using a Heroku, Vagrant or generic remote development environment,
  # use letter_opener_web, accessible at  /letter_opener.
  # Otherwise, use letter_opener, which launches a browser window to view sent mail.
  config.action_mailer.delivery_method = (ENV['HEROKU'] || ENV['VAGRANT'] || ENV['REMOTE_DEV']) ? :letter_opener_web : :letter_opener

  config.after_initialize do
    Bullet.enable        = true
    Bullet.bullet_logger = true
    Bullet.rails_logger  = false

    Bullet.add_whitelist type: :n_plus_one_query, class_name: 'User', association: :account
  end

  config.react.variant = :development
end

require 'sidekiq/testing'
Sidekiq::Testing.inline!

ActiveRecordQueryTrace.enabled = ENV.fetch('QUERY_TRACE_ENABLED') { false }

require 'oulipo/oulipo'
Oulipo.set_invalid_glyphs!(Oulipo::FIFTH_GLYPH_REGEX)
