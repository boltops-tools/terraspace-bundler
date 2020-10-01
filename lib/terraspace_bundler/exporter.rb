module TerraspaceBundler
  class Exporter
    include TB::Util::Logging

    def initialize(options={})
      @options = options
    end

    def run
      purge
      lockfile.mods.each do |mod|
        logger.info "Exporting #{mod.name}"
        export(mod)
      end
    end

    def export(mod)
      downloader = Mod::Downloader.new(mod)
      downloader.run
      downloader.switch_version(mod.sha)
      copy = Copy.new(mod)
      copy.mod
      copy.stacks
      logger.debug "Exported: #{copy.mod_path}"
    end

  private
    def purge
      return unless TB.config.export_purge
      FileUtils.rm_rf(TB.config.export_to)
    end

    def lockfile
      Lockfile.instance
    end
  end
end
