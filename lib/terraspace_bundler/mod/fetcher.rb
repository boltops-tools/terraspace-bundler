# Fetcher is a base class to both Downloader and Local.
#
# It also delegates with the instance method to Downloader and Local.
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
