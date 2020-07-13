class TerraspaceBundler::Mod
  class Locked
    include TB::Util::Registry

    attr_reader :name, :path, :source, :version
    def initialize(name, info)
      @name, @info = name.to_s, info

      @path = @info[:path]
      @version = @info[:version]
    end

    def source
      @info[:source]
    end

    def org
      obtain_org(source)
    end

    def repo
      s = registry?(source) ? registry_github : source
      File.basename(s)
    end

    def full_repo
      "#{org}/#{repo}"
    end

    def to_mod
      # copy all props in Terrafile.lock
      options = @info.clone
      # add org
      options.merge!(org: @org)

      data = {
        args: @name,
        options: options,
      }
      TB::Mod.new(data) # no need for global, info in the lockfile is enough
    end

    def export
      export = Export.new(self)
      export.run
    end
  end
end
