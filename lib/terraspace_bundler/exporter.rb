module TerraspaceBundler
  class Exporter
    include TB::Mod::PathConcern
    include TB::Util::Logging

    def initialize(options={})
      @options = options
    end

    def run
      purge_all
      mods.each do |mod|
        logger.info "Exporting #{mod.name}"
        purge(mod)
        export(mod)
      end
    end

    def mods
      mods = lockfile.mods
      if TB.update_mode? && !@options[:mods].empty?
        mods.select! { |mod| @options[:mods].include?(mod.name) }
      end
      mods
    end

    def export(mod)
      fetcher = Mod::Fetcher.new(mod).instance
      fetcher.run
      fetcher.switch_version(mod.sha)
      copy = Copy.new(mod)
      copy.mod
      copy.stacks
      logger.debug "Exported: #{copy.mod_path}"
    end

  private
    def purge_all
      return if TB.update_mode?
      return unless TB.config.export_purge
      FileUtils.rm_rf(TB.config.export_to)
    end

    def purge(mod)
      mod_path = get_mod_path(mod)
      FileUtils.rm_rf(mod_path)
    end

    def lockfile
      Lockfile.instance
    end
  end
end
