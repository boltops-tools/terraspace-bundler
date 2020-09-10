module TerraspaceBundler
  class Exporter
    include TB::Mod::PathConcern
    include TB::Util::Logging

    def initialize(options={})
      @options = options
    end

    def run
      purge
      lockfile.mods.each do |mod|
        export(mod)
      end
    end

    def export(mod)
      downloader = Mod::Downloader.new(mod)
      downloader.switch_version(mod.sha)

      stage_path = stage_path(mod.full_repo)
      stage_path = "#{stage_path}/#{mod.subfolder}" if mod.subfolder
      mod_path = mod_path(mod)
      FileUtils.rm_rf(mod_path)
      FileUtils.mkdir_p(File.dirname(mod_path))
      FileUtils.cp_r(stage_path, mod_path)
      FileUtils.rm_rf("#{mod_path}/.git")
      logger.debug "Exported: #{mod_path}"
    end

    def mod_path(mod)
      name = mod.name
      export_to = mod.export_to || TB.config.export_path
      "#{export_to}/#{name}"
    end

  private
    def purge
      return unless TB.config.export_purge
      FileUtils.rm_rf(TB.config.export_path)
    end

    def lockfile
      Lockfile.instance
    end
  end
end
