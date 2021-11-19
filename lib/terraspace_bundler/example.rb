module TerraspaceBundler
  class Example < TB::CLI::Base
    def run
      check_mod!
      stack = Exporter::Stacks::Stack.new(mod, stack_options)
      stack.export
      logger.info "Example from vendor/modules/#{@options[:mod]}/examples/#{@src} imported to #{@dest}/#{@name}"
    end

    def stack_options
      @name = @options[:name] || @options[:example]
      @purge = @options[:purge].nil? ? true : @options[:purge]
      @dest = @options[:dest] || "app/stacks"
      @src = @options[:example]
      {
        name: @name,
        src: @src,
        dest: @dest,
        purge: @purge,
      }
    end

    def mod
      lockfile.mods.find { |mod| mod.name == @options[:mod] }
    end

    def check_mod!
      unless mod
        logger.error "ERROR: mod #{@options[:mod]} not found in Terrafile.lock".color(:red)
        exit 1
      end
    end

  private
    def lockfile
      Lockfile.instance
    end
  end
end
