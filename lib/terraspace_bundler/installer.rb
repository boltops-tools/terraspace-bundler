module TerraspaceBundler
  class Installer < CLI::Base
    extend Memoist

    def initialize(options={})
      super
      @download = options[:download].nil? ? true : options[:download]
    end

    def run
      Setup.new(@options).setup!
      download
      export
      logger.info "Modules saved to #{TB.config.export_path}"
    end

    def download
      return unless @download

      if File.exist?(TB.config.lockfile)
        puts "Bundling modules from #{TB.config.lockfile}..."
      else
        Updater.new(@options).run(without_install: true) # creates Terrafile.lock
      end

      Syncer.new(mods).run
    end

    def export
      locked_mods.each(&:export)
    end

    def mods
      locked_mods.map(&:to_mod)
    end
    memoize :mods

    def locked_mods
      data = YAML.load_file(TB.config.lockfile).deep_symbolize_keys
      data.map do |name, info|
        Mod::Locked.new(name, info)
      end
    end
  end
end
