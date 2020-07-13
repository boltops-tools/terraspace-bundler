class TerraspaceBundler::Mod
  class Sync
    extend Memoist
    include TB::Helper::Git
    include TB::Logging
    include TB::Mod::TmpPaths

    attr_reader :sha
    def initialize(mod, url)
      @mod, @url = mod, url
    end

    def run
      setup_tmp
      org_path = "#{cache_root}/#{@mod.org}"
      FileUtils.mkdir_p(org_path)
      Dir.chdir(org_path) do
        name = File.basename(@url).sub('.git','')
        unless File.exist?(name)
          sh "git clone #{@url}"
        end

        Dir.chdir(name) do
          git "pull"
          git "submodule update --init"
          stage(name)
        end
      end
    end

    def stage(name)
      copy_to_stage(name)
      switch_to_specific_version(name)
    end

    def switch_to_specific_version(name)
      stage_path = stage_path("#{@mod.org}/#{name}")
      logger.debug "Within: #{stage_path}"
      Dir.chdir(stage_path) do
        git "checkout #{@mod.checkout_version}" if @mod.checkout_version
        @sha = git("rev-parse HEAD").strip
      end
    end

    def copy_to_stage(name)
      cache_path = cache_path("#{@mod.org}/#{name}")
      stage_path = stage_path("#{@mod.org}/#{name}")
      FileUtils.rm_rf(stage_path)
      FileUtils.mkdir_p(File.dirname(stage_path))
      FileUtils.cp_r(cache_path, stage_path)
    end
  end
end
