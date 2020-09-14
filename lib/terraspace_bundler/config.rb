module TerraspaceBundler
  class Config
    extend Memoist
    include Singleton

    def config
      config = ActiveSupport::OrderedOptions.new
      config.base_clone_url = "git@github.com:"
      config.export_path = ENV['TB_EXPORT_PATH'] || "vendor/modules"
      config.export_purge = ENV['TB_EXPORT_PRUNE'] == '0' ? false : true
      config.lockfile = "#{config.terrafile}.lock"
      config.logger = new_logger
      config.terrafile = ENV['TB_TERRAFILE'] || "Terrafile"
      config
    end
    memoize :config

    # Note: When using terraspace, Terraspace uses its own logger
    # So these settings dont affect: terraspace bundle
    # Instead, set the log level in the terraspace project: config/app.rb
    def new_logger
      logger = Logger.new(ENV['TB_LOG_PATH'] || $stderr)
      logger.level = ENV['TB_LOG_LEVEL'] || :info
      logger.formatter = Logger::Formatter.new
      logger
    end
  end
end
