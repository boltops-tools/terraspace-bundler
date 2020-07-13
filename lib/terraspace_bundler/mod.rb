module TerraspaceBundler
  class Mod
    extend Memoist
    include TB::Util::Registry

    attr_reader :branch, :ref, :tag, :sha, :source
    def initialize(data={}, global={})
      @data, @global = data, global
      @args = data[:args]
      @options = data[:options]

      # support variety of options, prefer version
      @version = @options[:version]
      @branch = @options[:branch]
      @ref = @options[:ref]
      @tag = @options[:tag]
    end

    def source
      if @options[:source].split('/').size == 1
        "#{org}/#{@options[:source]}"
      else
        @options[:source]
      end
    end

    def full_org
      normalize_git_url(org)
    end

    def org
      obtain_org(@options[:source], @global[:org])
    end

    def url
      normalize_url(source)
    end

    def normalize_url(source)
      return registry_github if registry?(source)
      normalize_git_url(source)
    end

    def path
      @options[:path]
    end

    def name
      @args.first
    end

    def version
      @version || @ref || @tag || @branch
    end

    def checkout_version
      v = version
      v = "v#{v}" if registry?(source) && @version && !v.starts_with?("v")
      v
    end

    def sync
      sync = Sync.new(self, url)
      sync.run
      @sha = sync.sha
    end
    memoize :sync

    def normalize_git_url(s)
      if git_url?(s)
        s
      else
        "#{base_url}#{s}"
      end
    end

    def base_url
      @global[:base_url] || "git@github.com:"
    end

    def git_url?(s)
      s.include?("http") || s.include?("git@")
    end
  end
end
