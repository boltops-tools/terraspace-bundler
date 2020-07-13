module TerraspaceBundler
  class Setup
    def initialize(options={})
      @options = options
    end

    def setup!
      # Run the DSL to possibly override the config defaults
      meta = Dsl.new.run
      export_path = meta[:global][:export_path]
      TB.config.export_path = export_path if export_path

      # cli --terrafile option
      if @options[:terrafile]
        TB.config.terrafile = @options[:terrafile]
        TB.config.lockfile = "#{@options[:terrafile]}.lock"
      end
    end
  end
end
