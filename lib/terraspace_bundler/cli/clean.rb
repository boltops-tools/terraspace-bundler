class TerraspaceBundler::CLI
  class Clean < Base
    include TB::Mod::TmpPaths
    include TB::Logging

    def run
      FileUtils.rm_rf(tmp_root)
      logger.info "Removed #{tmp_root}"
    end
  end
end
