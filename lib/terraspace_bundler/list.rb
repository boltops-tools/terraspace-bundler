module TerraspaceBundler
  class List < TB::CLI::Base
    def run
      file = TB.config.lockfile
      unless File.exist?(file)
        logger.info "No #{file} found".color(:red)
        logger.info "Maybe run: terraspace bundle"
        return
      end

      logger.info "Modules included by #{file}\n\n"
      lockfile.mods.each do |mod|
        logger.info "    #{mod.name}"
      end
      logger.info "\nUse `terraspace bundle info` to print more detailed information about a module"
    end

    def lockfile
      Lockfile.instance
    end
  end
end
