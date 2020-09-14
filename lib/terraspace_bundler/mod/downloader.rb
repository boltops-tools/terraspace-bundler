class TerraspaceBundler::Mod
  class Downloader
    extend Memoist
    include TB::Util::Git
    include TB::Util::Logging
    include TB::Mod::PathConcern

    attr_reader :sha
    def initialize(mod)
      @mod = mod
    end

    def run
      setup_tmp
      org_path = "#{cache_root}/#{@mod.org}"
      FileUtils.mkdir_p(org_path)

      Dir.chdir(org_path) do
        unless File.exist?(@mod.repo)
          sh "git clone #{@mod.url}"
        end

        Dir.chdir(@mod.repo) do
          git "pull"
          git "submodule update --init"
          stage
        end
      end
    end

    def stage
      copy_to_stage
      # TODO: if there's no master, need to checkout if its the default branch
      checkout = @mod.checkout_version || "master"
      switch_version(checkout)
    end

    def switch_version(version)
      stage_path = stage_path("#{@mod.org}/#{@mod.repo}")
      logger.debug "Within: #{stage_path}"
      Dir.chdir(stage_path) do
        git "checkout #{version}"
        @sha = git("rev-parse HEAD").strip
      end
    end

    def copy_to_stage
      cache_path = cache_path("#{@mod.org}/#{@mod.repo}")
      stage_path = stage_path("#{@mod.org}/#{@mod.repo}")
      FileUtils.rm_rf(stage_path)
      FileUtils.mkdir_p(File.dirname(stage_path))
      FileUtils.cp_r(cache_path, stage_path)
    end
  end
end
