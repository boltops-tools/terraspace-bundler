class TerraspaceBundler::Mod
  class Export
    include TmpPaths

    def initialize(locked_mod)
      @locked_mod = locked_mod
    end

    def run
      stage_path = stage_path(@locked_mod.full_repo)
      stage_path = "#{stage_path}/#{@locked_mod.path}" if @locked_mod.path
      export_path = export_path(@locked_mod.name)
      FileUtils.rm_rf(export_path)
      FileUtils.mkdir_p(File.dirname(export_path))
      FileUtils.cp_r(stage_path, export_path)
      FileUtils.rm_rf("#{export_path}/.git")
    end

    def export_path(repo)
      "#{TB.config.export_path}/#{repo}"
    end
  end
end
