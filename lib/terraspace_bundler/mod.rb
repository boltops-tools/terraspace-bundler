module TerraspaceBundler
  class Mod
    extend PropsExtension
    props :export_to, :name, :sha, :source, :subfolder, :type, :url

    include StackConcern

    attr_reader :props, :version, :ref, :tag, :branch
    def initialize(props={})
      @props = props.symbolize_keys
      # These props are used for version comparing by VersionComparer
      @version, @ref, @tag, @branch = @props[:version], @props[:ref], @props[:tag], @props[:branch]
    end

    def checkout_version
      v = detected_version
      v = "v#{v}" if type == "registry" && @version && !v.starts_with?("v")
      v
    end

    # use url instead of source because for registry modules, the repo name is different
    def repo
      url_words[-1]
    end

    def org
      url_words[-2] # second to last word
    end

    def full_repo
      "#{org}/#{repo}"
    end

    def latest_sha
      downloader = Downloader.new(self)
      downloader.run
      downloader.sha
    end

  private
    # support variety of options, prefer version
    def detected_version
      @version || @ref || @tag || @branch
    end

    def url_words
      url.split('/')
    end
  end
end
