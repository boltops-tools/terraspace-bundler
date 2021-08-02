class TerraspaceBundler::Mod
  class Downloader < Fetcher
    extend Memoist

    def run
      setup_tmp
      org_path = cache_path(@mod.org)
      FileUtils.mkdir_p(org_path)

      Dir.chdir(org_path) do
        logger.debug "Current root dir: #{org_path}"
        clone unless File.exist?(@mod.repo)

        Dir.chdir(@mod.repo) do
          logger.debug "Change dir: #{@mod.repo}"
          git "pull"
          git "submodule update --init"
          stage
        end
      end
    end
    memoize :run

    def clone
      sh "git clone #{@mod.url}"
    rescue TB::GitError => e
      logger.error "ERROR: #{e.message}".color(:red)
      exit 1
    end

    def stage
      copy_to_stage
      checkout = @mod.checkout_version || default_branch
      switch_version(checkout)
    end

    # Note: if not in a git repo, will get this error message in stderr
    #
    #    fatal: Not a git repository (or any of the parent directories): .git
    #
    def default_branch
      origin = `git remote show origin`.strip
      found = origin.split("\n").find { |l| l.include?("HEAD") }
      if found
        found.split(':').last.strip
      else
        'master'
      end
    end

    def switch_version(version)
      stage_path = stage_path("#{@mod.copy_source_path}")
      # logger.debug "Within: #{stage_path}"
      Dir.chdir(stage_path) do
        git "checkout #{version}"
        @sha = git("rev-parse HEAD").strip
      end
    end

    def copy_to_stage
      cache_path = cache_path("#{@mod.copy_source_path}")
      stage_path = stage_path("#{@mod.copy_source_path}")
      FileUtils.rm_rf(stage_path)
      FileUtils.mkdir_p(File.dirname(stage_path))
      puts "copy_to_stage cp -r #{cache_path} #{stage_path}"
      FileUtils.cp_r(cache_path, stage_path)
    end
  end
end
