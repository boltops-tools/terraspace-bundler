module TerraspaceBundler
  class Updater
    include Logging

    def initialize(options={})
      @options = options
      @mod_name = @options[:mod]
    end

    def run(without_install: false)
      Setup.new(@options).setup!
      puts "Bundling modules from #{TB.config.terrafile}..."

      if update_one?
        update_one
      else
        update_all
      end
      unless without_install
        Installer.new(@options.merge(download: false)).run
      end
    end

    def update_one?
      @mod_name && File.exist?(TB.config.lockfile)
    end

    def update_one
      meta = Dsl.new.run
      mods = meta[:mods].map { |data| Mod.new(data, meta[:global]) }
      mod = mods.find { |m| m.name == @mod_name }
      unless mod
        logger.error "No module #{@mod_name} found in your Terrafile"
        exit 1
      end
      mod.sync
      Lockfile.new.update_one(mod)
    end

    def update_all
      meta = Dsl.new.run
      mods = meta[:mods].map { |data| Mod.new(data, meta[:global]) }
      mods.each do |mod|
        mod.sync
      end
      Lockfile.new(mods).create
    end
  end
end
