module TerraspaceBundler
  class Syncer
    include TB::Util::Logging

    def initialize(options={})
      @options = options
      @mod_name = @options[:mod]
    end

    def run
      validate!
      FileUtils.rm_f(TB.config.lockfile) if update_all?
      logger.info "Bundling with #{TB.config.terrafile}..."
      if File.exist?(TB.config.lockfile)
        sync
      else
        create
      end
      TB::Lockfile.write
    end

    def sync
      sync_mods
      removed_mods = subtract(lockfile.mods, terrafile.mods)
      lockfile.prune(removed_mods)
    end

    def create
      sync_mods
    end

    def sync_mods
      # VersionComparer is used in lockfile.sync and does heavy lifting to check if mod should be updated and replaced
      terrafile.mods.each do |mod|
        next unless sync?(mod)
        logger.debug "Syncing #{mod.name}"
        lockfile.sync(mod) # update (if version mismatch) or create (if missing)
      end
    end

    def sync?(mod)
      names = @options[:mods]
      names.blank? or names.include?(mod.name)
    end

    def validate!
      return unless terrafile.missing_org?
      logger.error "ERROR: org must be set in the #{TB.config.terrafile}.".color(:red)
      logger.error "Please set org in the Terrafile"
      exit 1
    end

    def update_all?
      @options[:mode] == "update" && @options[:mods].empty?
    end

    def subtract(mods1, mods2)
      mod2_names = mods2.map(&:name)
      mods1.select {|mod1| !mod2_names.include?(mod1.name) }
    end

    def terrafile
      Terrafile.instance
    end

    def lockfile
      Lockfile.instance
    end
  end
end
