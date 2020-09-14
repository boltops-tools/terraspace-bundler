module TerraspaceBundler
  class Mod
    extend PropsExtension
    props :name, :source, :url, :subfolder, :type, :export_to

    attr_reader :props, :version, :ref, :tag, :branch
    def initialize(props={})
      @props = props.symbolize_keys
      # These props are used for version comparing by VersionComparer
      @version, @ref, @tag, @branch = @props[:version], @props[:ref], @props[:tag], @props[:branch]
    end

    def sha
      # sha will already be set if coming from Terrafile.lock
      # sha will be lazily fetch set if coming from Terrafile
      @props[:sha] ||= fetch_sha
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

  private
    def fetch_sha
      downloader = Downloader.new(self)
      downloader.run
      downloader.sha
    end
    # support variety of options, prefer version
    def detected_version
      @version || @ref || @tag || @branch
    end

    def url_words
      url.split('/')
    end
  end
end
