require 'uri'

# Use to build mod from Terrafile entry.
# The Terrafile.lock does not need this because it's simple and just merges the data.
class TerraspaceBundler::Mod
  class Props
    extend Memoist

    delegate :type, to: :typer

    attr_reader :source
    def initialize(params={})
      @params = params
      @options = params[:options]
      @source, @version = @options[:source], @options[:version]
    end

    def build
      o = @options.merge(
        name: name,
        type: type,
        url: url,
      )
      o[:subfolder] ||= subfolder_slash_notation(@source)
      o[:ref] ||= ref_slash_notation(@source)
      o
    end

    def subfolder_slash_notation(source)
      parts = source.split('//')
      unless parts.size == 1 || parts.size == 2 && source.include?('http')
        parts.last
      end
    end

    def ref_slash_notation(source)
      source = "tongueroo/example-module//subfolder?ref=92cafe7fca2a90d8de2245f3a0a9a47002bd0b95"
      uri = URI(source)
      params = URI::decode_www_form(uri.query).to_h # if you are in 2.1 or later version of Ruby
      params['ref']
    end

    def name
      remove_special_notations(@params[:args].first)
    end

    # url is normalized
    def url
      url = type == 'registry' ? registry.github_url : git_source_url
      remove_special_notations(clone_with(url))
    end

    def remove_special_notations(source)
      # puts "remove_special_notations:"
      x = remove_ref_notation(source)
      y = remove_subfolder_notation(x)
      # puts "source: #{source}"
      # puts "x #{x}"
      # puts "y #{y}"
      y
    end

    def remove_ref_notation(source)
      source.sub(/\?.*/,'')
    end

    def source_without_subfolder
      remove_subfolder_notation(@source)
    end

    def remove_subfolder_notation(source)
      parts = source.split('//')
      # puts "parts #{parts}"
      if parts.size == 1 || parts.size == 2 && source.include?('http')
        source
      else
        parts[0..-2].join('//')
      end
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
