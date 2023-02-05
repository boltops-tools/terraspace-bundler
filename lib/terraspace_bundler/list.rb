module TerraspaceBundler
  class List < TB::CLI::Base
    include Util::NormalizeVersion

    def run
      file = TB.config.lockfile
      unless File.exist?(file)
        logger.info "No #{file} found".color(:red)
        logger.info "Maybe first run: terraspace bundle"
        return
      end

      logger.info "Modules included by #{file}\n\n"
      lockfile.mods.each do |mod|
        if mod.outdated_supported?
          current_version = " (#{normalize_version(mod.current_version)})"
        end
        logger.info "    #{mod.name}#{current_version}"
      end
      logger.info "\nUse `terraspace bundle info` to print more detailed information about a module"
    end

    def lockfile
      Lockfile.instance
    end
  end
end
