# Mimic internal interface of Mod::Downloader. These methods are used:
#
#   downloader.run
#   downloader.switch_version(mod.sha)
#   downloader.sha
#
class TerraspaceBundler::Mod
  class Local < Fetcher
    def run
      dest = stage_path(@mod.copy_source_path)
      source = @mod.source
      source.sub!(/^~/, ENV['HOME'])
      FileUtils.rm_rf(dest)
      FileUtils.mkdir_p(File.dirname(dest))
      FileUtils.cp_r(source, dest)
    end

    def switch_version(*)
      # noop
    end
  end
end
