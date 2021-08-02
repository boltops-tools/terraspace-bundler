class TerraspaceBundler::Mod::Fetcher
  class Base
    include TB::Util::Git
    include TB::Util::Logging
    include TB::Mod::Concerns::PathConcern

    attr_reader :sha # returns nil for Local
    def initialize(mod)
      @mod = mod
    end
  end
end
