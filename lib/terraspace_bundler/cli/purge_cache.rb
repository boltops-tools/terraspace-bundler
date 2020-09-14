class TerraspaceBundler::CLI
  class PurgeCache < Base
    include TB::Mod::PathConcern
    include TB::Util::Logging

    def run
      FileUtils.rm_rf(tmp_root)
      logger.info "Removed #{tmp_root}"
    end
  end
end
