require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module DocShare
  class Application < Rails::Application
    config.i18n.load_path += Dir[%Q`#{config.root}/config/locales/**/*.{rb,yml}`]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
    config.active_record.observers = :target_follower_observer, :repository_observer,
                                      :message_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]
    config.generators do |g|
      g.template_engine :haml
    end

    config.cache_store = :redis_store, "redis://#{ YAML.load_file(%Q`#{config.root}/config/resque.yml`)[Rails.env] }"

    config.middleware.use ExceptionNotifier,
                    :email_prefix => "[Whatever] ",
                    :sender_address => %{"137518792" <137518792@qq.com>},
                    :exception_recipients => %w{122755990@qq.com}

    config.generators do |g|
      g.fixture_replacement :machinist
    end

    config.generators do |g|
      g.test_framework  :rspec, :fixture => true, :views => false
      g.integration_tool :rspec, :fixture => true, :views => false
    end

    config.autoload_paths += %W(
      #{config.root}/lib
      #{config.root}/app/models/common
      )

    #
    config.time_zone = 'Beijing'
    config.active_record.default_timezone = :local

    #
    config.i18n.locale = config.i18n.default_locale = 'zh-CN'
    I18n.default_locale = 'zh-CN'

    #
    config.logger = Logger.new(config.paths["log"].first, 'weekly')

    #
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.perform_deliveries = true
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings =
        Hash[ YAML.load_file(%Q`#{config.root}/config/smtp_settings.yml`)[Rails.env].map {|k,v| [k.to_sym, v]} ]

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'
  end
end
ActiveSupport::XmlMini.backend = 'Nokogiri'

