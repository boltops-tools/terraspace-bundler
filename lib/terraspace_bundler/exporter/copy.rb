class TerraspaceBundler::Exporter
  class Copy < Base
    def initialize(mod)
      @mod = mod
    end

    def mod
      FileUtils.rm_rf(mod_path)
      FileUtils.mkdir_p(File.dirname(mod_path))
      FileUtils.cp_r(src_path, mod_path)
      FileUtils.rm_rf("#{mod_path}/.git")
    end

    def stacks
      Stacks.new(@mod).export
    end

    # src path is from the stage area
    def src_path
      path = stage_path(@mod.full_repo) # from PathConcern
      path = "#{path}/#{@mod.subfolder}" if @mod.subfolder
      path
    end
  end
end
