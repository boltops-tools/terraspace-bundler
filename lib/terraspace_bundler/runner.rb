module TerraspaceBundler
  class Runner < CLI::Base
    def run
      Syncer.new(@options).run
      Exporter.new(@options).run
      finish_message
    end

    def finish_message
      no_modules_found = true
      export_paths.each do |path|
        found = Dir.exist?(path) && !Dir.empty?(path)
        next unless found
        logger.info  "Modules saved to #{path}"
        no_modules_found = false
      end

      logger.info("No modules were found.") if no_modules_found
    end

    def export_paths
      export_paths = Terrafile.instance.mods.map(&:export_to).compact.uniq
      export_paths << TB.config.export_to
      export_paths
    end
  end
end
