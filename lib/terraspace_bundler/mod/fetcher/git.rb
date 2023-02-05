require "version_sorter"

class TerraspaceBundler::Mod::Fetcher
  class Git < Base
    extend Memoist

    def run
      sync_cache
      stage
    end
    memoize :run

    def sync_cache
      setup_tmp
      org_folder = cache_path(@mod.org_folder)
      FileUtils.mkdir_p(org_folder)

      Dir.chdir(org_folder) do
        logger.debug "Current root dir: #{org_folder}"
        clone unless File.exist?(@mod.repo)

        Dir.chdir(@mod.repo) do
          logger.debug "Change dir: #{@mod.repo}"
          git "pull"
          git "submodule update --init"
          # make available to other methods
          @full_cache_path = "#{org_folder}/#{@mod.repo}"
          @tags_map = build_tags_map
          @head_sha = git("rev-parse HEAD").strip
          @commits_ahead = get_commits_ahead
        end
      end

      @full_cache_path
    end

    def sync_cache_at_least_once
      sync_cache unless @full_cache_path
    end

    attr_reader :commits_ahead
    def get_commits_ahead
      count = git("rev-list --count #{current_version}..#{latest_version}").strip.to_i
      if count == 0
        count = git("rev-list --count #{latest_version}..#{current_version}").strip.to_i
        count * -1
      else
        count
      end
    end

    def clone
      command = ["git clone", ENV['TB_GIT_CLONE_ARGS'], @mod.url].compact.join(' ')
      sh command
    rescue TB::GitError => e
      logger.error "ERROR: #{e.message}".color(:red)
      exit 1
    end

    def stage
      copy_to_stage
      Dir.chdir(@full_stage_path) do
        version = @mod.checkout_version || default_branch
        switch_version(version)
      end
    end

    def current_version
      if @mod.tag
        @mod.tag
      elsif @mod.sha
        @tags_map.invert[@mod.sha] || @mod.sha
      end
    end

    def latest_version
      tags = VersionSorter.sort(@tags_map.keys)
      tags.last || @head_sha
    end

    def outdated?
      sync_cache_at_least_once
      outdated = nil
      Dir.chdir(@full_cache_path) do
        outdated = current_version != latest_version
      end
    end

    def outdated_supported?
      sync_cache_at_least_once
      true
    end

    # tag to sha map
    def build_tags_map
      # git show-ref --tags
      # ed153406947400bf008f24f60014bc14cf1c8f9c refs/tags/v3.8.0
      # 7139ffe700d402f2360d0772fefb8001ff19a097 refs/tags/v3.9.0
      return {} if git("tag").split("\n").empty? # no tags yet
      git("show-ref --tags").split("\n").map do |line|
        sha, tag = line.split(' ')
        tag = tag.split('/').last # refs/tags/v3.9.0 => v3.9.0
        [tag, sha]
      end.to_h
    end
    memoize :build_tags_map

    # Note: if not in a git repo, will get this error message in stderr
    #
    #    fatal: Not a git repository (or any of the parent directories): .git
    #
    def default_branch
      origin = `git symbolic-ref refs/remotes/origin/HEAD`.strip
      if origin.empty?
        ENV['TS_GIT_DEFAULT_BRANCH'] || 'master'
      else
        origin.split('/').last
      end
    end

    def switch_version(version)
      stage_path = stage_path(rel_dest_dir)
      logger.debug "rel_dest_dir #{rel_dest_dir}"
      logger.debug "stage_path #{stage_path}"
      Dir.chdir(stage_path) do
        git "checkout #{version}"
        @sha = git("rev-parse HEAD").strip
      end
    end

    def copy_to_stage
      cache_path = cache_path(rel_dest_dir)
      stage_path = stage_path(rel_dest_dir)
      FileUtils.rm_rf(stage_path)
      FileUtils.mkdir_p(File.dirname(stage_path))
      FileUtils.cp_r(cache_path, stage_path)
      @full_stage_path = stage_path # make available to other methods
    end
  end
end
