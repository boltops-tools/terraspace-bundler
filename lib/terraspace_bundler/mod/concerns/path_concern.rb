module TerraspaceBundler::Mod::Concerns
  module PathConcern
    def setup_tmp
      FileUtils.mkdir_p(cache_root)
      FileUtils.mkdir_p(stage_root)
    end

    def tmp_root
      "/tmp/terraspace/bundler"
    end

    def cache_root
      "#{tmp_root}/cache"
    end

    def stage_root
      "#{tmp_root}/stage"
    end

    def cache_path(name)
      "#{cache_root}/#{parent_stage_folder}/#{name}"
    end

    def stage_path(name)
      "#{stage_root}/#{parent_stage_folder}/#{name}"
    end

    # Fetcher: Downloader/Local copies to a slightly different folder.
    # Also, Copy will use this and reference same method so it's consistent.
    def mod_relative_path
      x = case @mod.type
      when 'local'
        @mod.name
      when -> (_) { @mod.source.include?('::') }
        @mod.source # IE: full path that includes git:: s3:: gcs::
      else # git, registry
        @mod.full_repo
      end
      puts "mod_relative_path #{x}".color(:yellow)
      x
    end

    def parent_stage_folder
      @mod.local? ? "local" : @mod.vcs_provider
    end

    def mod_path
      get_mod_path(@mod)
    end

    def get_mod_path(mod)
      export_to = mod.export_to || TB.config.export_to
      "#{export_to}/#{mod.name}"
    end
  end
end
