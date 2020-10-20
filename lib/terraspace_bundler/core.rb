module TerraspaceBundler
  module Core
    extend Memoist

    @@logger = nil
    def logger
      config.logger
    end

    def logger=(v)
      @@logger = v
    end

    def config
      Config.instance.config
    end

    # DSL is evaluated once lazily when it get used
    def dsl
      dsl = Dsl.new
      dsl.run
      dsl
    end
    memoize :dsl

    @@update_mode = false
    def update_mode
      @@update_mode
    end
    alias_method :update_mode?, :update_mode

    def update_mode=(v)
      @@update_mode = v
    end
  end
end
