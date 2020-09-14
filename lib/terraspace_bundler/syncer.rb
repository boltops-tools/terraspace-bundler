module TerraspaceBundler
  class Syncer
    include TB::Util::Logging
    include Dsl::Concern

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
      terrafile.mods.each do |mod|
        update = update?(mod)
        next unless update
        lockfile.sync(mod) # update (if version mismatch) or create (if missing)
      end
    end

    def update?(mod)
      names = @options[:mods]
      return true if names.nil? || names.empty? # when empty never skip update
      names.include?(mod.name)
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
