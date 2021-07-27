# Delegates to:
#
#   1. Local
#   2. Git
#
class TerraspaceBundler::Mod
  class Fetcher
    def initialize(mod)
      @mod = mod
    end

    def instance
      type = @mod.type == "registry" ? "git" : @mod.type
      klass = "TerraspaceBundler::Mod::Fetcher::#{type.camelize}".constantize
      klass.new(@mod) # IE: Local.new(@mod), Git.new(@mod), S3.new(@mod), etc
    end
  end
end
