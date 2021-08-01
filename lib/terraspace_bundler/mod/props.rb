# Use to build mod from Terrafile entry.
# The Terrafile.lock does not need this because it's simple and just merges the data.
class TerraspaceBundler::Mod
  class Props
    extend Memoist

    delegate :type, :registry?, to: :typer

    attr_reader :source
    def initialize(params={})
      @params = params
      @options = params[:options]
      @source, @version = @options[:source], @options[:version]
    end

    def build
      @options.merge(
        name: name,
        normalized_source: normalized_source,
        type: type,
        url: url,
      )
    end

    def name
      @params[:args].first
    end

    # do not use the name source. @options is a copy though
    def normalized_source
      source = if registry?
        @source
      else
        @source.include?('/') ? @source : "#{TB.config.org}/#{@source}"
      end
    end

    def url
      url = if registry?
        registry.github_url
      else
        git_source_url
      end
      # sub to allow for generic git repo notiation
      #   IE: git::https://example.com/example-module.git
      url.sub('git::','')
    end

    def git_source_url
      if @source.include?('http') || @source.include?(':')
        # Examples:
        #   mod "pet", source: "https://github.com/tongueroo/pet"
        #   mod "pet", source: "git@github.com:tongueroo/pet"
        #   mod "pet", source: "git@gitlab.com:foo/tongueroo/pet"
        @source
      else
        # Examples:
        #   mod "pet", source: "tongueroo/pet"
        "#{TB.config.base_clone_url}#{normalized_source}" # Note: make sure to not use @source, org may not be added
      end
    end

    def typer
      Typer.new(self)
    end
    memoize :typer

    def registry
      Registry.new(@source, @version)
    end
    memoize :registry
  end
end
