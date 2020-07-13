module TerraspaceBundler
  module Core
    extend Memoist

    @@logger = nil
    def logger
      return @@logger if @@logger
      @@logger = Logger.new($stdout)
      @@logger.level = ENV['TB_LOG_LEVEL'] || 'info'
      @@logger
    end

    def logger=(v)
      @@logger = v
    end

    def config
      Config.instance.config
    end
  end
end
