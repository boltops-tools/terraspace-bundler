module TerraspaceBundler
  class Config
    extend Memoist
    include Singleton

    def config
      config = ActiveSupport::OrderedOptions.new
      config.export_path = "vendor/modules"
      config.terrafile = "Terrafile"
      config.lockfile = "#{config.terrafile}.lock"
      config
    end
    memoize :config
  end
end
