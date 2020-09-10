module TerraspaceBundler
  class Info < TB::CLI::Base
    def run
      name = @options[:mod]
      found = lockfile.mods.find { |m| m.name == @options[:mod] }
      if found
        show(found)
      else
        logger.info "Could not find module in #{TB.config.lockfile}: #{name}".color(:red)
      end
    end

    def show(mod)
      props = mod.props.reject { |k,v| k == :name }.stringify_keys # for sort
      puts "#{mod.name}:"
      props.keys.sort.each do |k|
        puts "    #{k}: #{props[k]}"
      end
    end

    def lockfile
      Lockfile.instance
    end
  end
end
