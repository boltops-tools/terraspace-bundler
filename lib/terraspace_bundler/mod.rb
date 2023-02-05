module TerraspaceBundler
  class Mod
    extend Memoist
    extend Props::Extension
    props :export_to, :name, :sha, :source, :subfolder, :type, :url, :clone_with
    delegate :repo, :org, :repo_folder, :org_folder, to: :org_repo

    include Concerns::StackConcern
    include Concerns::LocalConcern

    attr_reader :props, :version, :ref, :tag, :branch
    def initialize(props={})
      @props = props.symbolize_keys
      # These props are used for version comparing by VersionComparer
      @version, @ref, @tag, @branch = @props[:version], @props[:ref], @props[:tag], @props[:branch]
    end

    # support variety of options, prefer version
    def checkout_version
      @version || @ref || @tag || @branch
    end

    delegate :sync_cache, :outdated?, :outdated_supported?, :current_version, :latest_version, :commits_ahead, to: :fetcher
    def fetcher
      Fetcher.new(self).interface
    end
    memoize :fetcher

    def latest_sha
      fetcher.run
      fetcher.sha
    end

    def vcs_provider
      if url.include?('http')
        # "https://github.com/org/repo"  => github.com
        url.match(%r{http[s]?://(.*?)/})[1]
      elsif url.include?('http') # git@
        # "git@github.com:org/repo"      => github.com
        url.match(%r{git@(.*?):})[1]
      else # ssh://user@domain.com/path/to/repo
        'none'
      end
    end

  private
    def org_repo
      OrgRepo.new(url)
    end
    memoize :org_repo
  end
end
