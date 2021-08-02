class TerraspaceBundler::Mod::Fetcher
  class S3 < Base
    def run
      dest = stage_path(@mod.copy_source_path)
      source = @mod.source
      src = source.sub(/^~/, ENV['HOME']) # allow ~/ notation
      FileUtils.rm_rf(dest)
      FileUtils.mkdir_p(File.dirname(dest))
      FileUtils.cp_r(src, dest)
    end

    def switch_version(*)
      # noop
    end
  end
end
