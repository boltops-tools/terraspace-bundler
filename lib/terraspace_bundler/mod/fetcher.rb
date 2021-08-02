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
      if @mod.type == "local"
        Local.new(@mod)
      else
        Git.new(@mod)
      end
    end
  end
end
