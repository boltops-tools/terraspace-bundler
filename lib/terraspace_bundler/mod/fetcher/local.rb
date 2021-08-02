class TerraspaceBundler::Mod::Fetcher
  class Local < Base
    def run
      stage_path = stage_path(@mod.stage_relative_path)
      source = @mod.source
      src = source.sub(/^~/, ENV['HOME']) # allow ~/ notation
      FileUtils.rm_rf(stage_path)
      FileUtils.mkdir_p(File.dirname(stage_path))
      logger.debug "Local: cp -r #{src} #{stage_path}"
      # copy from stage area to vendor/modules/NAME
      # IE: cp -r /tmp/terraspace/bundler/stage/local/local1 vendor/modules/local1
      FileUtils.cp_r(src, stage_path)
    end
  end
end
