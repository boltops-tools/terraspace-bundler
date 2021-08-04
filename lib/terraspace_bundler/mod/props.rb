# Use to build mod from Terrafile entry.
# The Terrafile.lock does not need this because it's simple and just merges the data.
class TerraspaceBundler::Mod
  class Props
    extend Memoist
    include Concerns::NotationConcern
    include TB::Util::Logging

    delegate :type, to: :typer

    attr_reader :source
    def initialize(params={})
      @params = params
      @options = params[:options]
      @source, @version = @options[:source], @options[:version]
    end

    def name
      remove_notations(@params[:args].first)
    end

    def build
      unless @source
        logger.error "ERROR: The source option must be set for the #{name} mod in the Terrafile".color(:red)
        exit 1
      end
      o = @options.merge(
        name: name,
        type: type,
        url: url,
      )
      o[:subfolder] ||= subfolder(@source)
      o[:ref] ||= ref(@source)
      o
    end

    # url is normalized
    def url
      url = case type
            when 'registry'
              registry.github_url
            when 'local'
              source
            else # git
              git_source_url
            end
      remove_notations(clone_with(url))
    end

    # apply clone_with option if set
    def clone_with(url)
      with = @options[:clone_with] || TB.config.clone_with
      return url unless with
      if with == 'https'
        url.sub(/.*@(.*):/,'https://\1/')
      else # git@
        url.sub(%r{http[s]?://(.*?)/},'git@\1:')
      end
    end

    # git_source_url is normalized
    def git_source_url
      if @source.include?('http') || @source.include?(':')
        # Examples:
        #   mod "pet1", source: "https://github.com/tongueroo/pet"
        #   mod "pet2", source: "git@github.com:tongueroo/pet"
        #   mod "pet3", source: "git@gitlab.com:tongueroo/pet"
        #   mod "pet4", source: "git@bitbucket.org:tongueroo/pet"
        #   mod "example3", source: "git::https://example.com/example-module.git"
        #
        # sub to allow for generic git repo notiation
        @source.sub('git::','')
      else
        # Examples:
        #   mod "pet", source: "tongueroo/pet"
        # Or:
        #   org "tongueroo"
        #   mod "pet", source: "pet"
        org_source = @source.include?('/') ? @source : "#{TB.config.org}/#{@source}" # adds inferred org
        "#{TB.config.base_clone_url}#{org_source}"
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
