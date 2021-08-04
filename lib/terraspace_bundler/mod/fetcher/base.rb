# Interface of subclasses should implement
#
#   run
#   switch_version(mod.sha)
#   sha
#
class TerraspaceBundler::Mod::Fetcher
  class Base
    include TB::Util::Git
    include TB::Util::Logging
    include TB::Mod::Concerns::PathConcern

    attr_reader :sha # returns nil for Local
    def initialize(mod)
      @mod = mod
    end

    def switch_version(*)
      # noop
    end

    def extract(archive, dest)
      TerraspaceBundler::Extract.extract(archive, dest)
    end

  end
end
