module TerraspaceBundler
  class Mod
    extend Props::Extension
    props :export_to, :name, :sha, :source, :subfolder, :type, :url, :clone_with

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

    # use url instead of source because for registry modules, the repo name is different
    def repo
      url_words[-1].sub(/\.git$/,'')
    end

    # https://github.com/tongueroo/pet - 2nd to last word
    # git@github.com:tongueroo/pet - 2nd to last word without chars before :
    def org
      # puts "url_words #{url_words}"
      # pp url_words
      s = url_words[-2] # second to last word
      s.split(':').last # in case of git@github.com:tongueroo/pet form
    end

    def full_repo
      "#{org}/#{repo}"
    end

    def latest_sha
      fetcher = Fetcher.new(self).instance
      fetcher.run
      fetcher.sha
    end

    def vcs_provider
      if url.include?('http')
        # "https://github.com/org/repo"  => github.com
        url.match(%r{http[s]?://(.*?)/})[1]
      else # git@
        # "git@github.com:org/repo"      => github.com
        url.match(%r{git@(.*?):})[1]
      end
    end

    # Fetcher: Downloader/Local copies to a slightly different folder.
    # Also, Copy will use this and reference same method so it's consistent.
    def stage_relative_path
      x = case type
      when 'local'
        name
      when -> (_) { source.include?('::') }
        source # IE: full path that includes git:: s3:: gcs::
      else # git, registry
        full_repo
      end
      puts "stage_relative_path #{x}".color(:yellow)
      x
    end

  private
    def url_words
      url.split('/')
    end
  end
end
