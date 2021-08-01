# Fetcher delegates to with instance method:
#
#   1. Downloader
#   2. Local
#
class TerraspaceBundler::Mod
  class Fetcher
    include TB::Util::Git
    include TB::Util::Logging
    include TB::Mod::PathConcern

    attr_reader :sha # returns nil for Local
    def initialize(mod)
      @mod = mod
    end

    def instance
      if @mod.type == "local"
        Local.new(@mod)
      else
        Downloader.new(@mod)
      end
    end
  end
end
