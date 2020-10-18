# Use to build mod from Terrafile entry.
# The Terrafile.lock does not need this because it's simple and just merges the data.
class TerraspaceBundler::Mod
  class PropsBuilder
    extend Memoist

    def initialize(params={})
      @params = params
      @options = params[:options]
      @source, @version = @options[:source], @options[:version]
    end

    def build
      @options.merge(
        name: name,
        source: source, # overwrite source. @options is a copy though
        type: type,
        url: url,
      )
    end

    def name
      @params[:args].first
    end

    def source
      if registry?
        @source
      else
        @source.include?('/') ? @source : "#{TB.config.org}/#{@source}"
      end
    end

    def url
      if registry?
        registry.github_url
      else
        "#{TB.config.base_clone_url}#{source}" # Note: make sure to not use @source, is org may no be added
      end
    end

    # IE: git or registry
    def type
      registry? ? "registry" : "git"
    end

    def registry?
      !@source.nil? && @source.split('/').size == 3
    end

    def registry
      Registry.new(@source, @version)
    end
    memoize :registry
  end
end
