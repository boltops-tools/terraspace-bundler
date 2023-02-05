module TerraspaceBundler
  class Info < TB::CLI::Base
    include Util::NormalizeVersion

    def run
      file = TB.config.lockfile
      unless File.exist?(file)
        logger.info "No #{file} found".color(:red)
        logger.info "Maybe first run: terraspace bundle"
        return
      end

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

      props = props.dup
      # Only git fetcher supported currently. IE: s3 is not supported.
      if mod.outdated_supported?
        current_version = " (#{normalize_version(mod.current_version)})"
      end

      puts "#{mod.name}#{current_version}"
      props.keys.sort.each do |k|
        puts "    #{k}: #{props[k]}"
      end
    end

    def lockfile
      Lockfile.instance
    end
  end
end
