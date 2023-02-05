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

    # If outdated? is implemented, subclass should also implement:
    # current_version, latest_version, commits_ahead, and outdated_supported?
    # See git fetcher for example.
    def outdated?(*)
      logger.debug "WARN: outdated? called for #{@mod.name}. outdated? not supported by #{self.class}"
      # return nil. It's used to filter out fetchers that don't support outdated
      nil
    end

    def outdated_supported?
      false
    end

  end
end
