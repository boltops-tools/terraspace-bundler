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
      [cache_root, parent_stage_folder, name].compact.join('/')
    end

    def stage_path(name)
      [stage_root, parent_stage_folder, name].compact.join('/')
    end

    # Fetcher: Downloader/Local copies to a slightly different folder.
    # Also, Copy will use this and reference same method so it's consistent.
    def rel_dest_dir
      case @mod.type
      when 'local'
        @mod.name      # example-module
      when 's3'
        path = type_path # https://s3-us-west-2.amazonaws.com/demo-terraform-test/example-module.zip
        remove_ext(path) # demo-terraform-test/modules/example-module
      when 'gcs'
        path = type_path # https://www.googleapis.com/storage/v1/BUCKET_NAME/PATH/TO/module.zip
        path.sub!(%r{storage/v\d+/},'')
        remove_ext(path) # terraform-example-modules/modules/example-module
      when 'http'
        path = type_path # https://www.googleapis.com/storage/v1/BUCKET_NAME/PATH/TO/module.zip
        remove_ext(path) # terraform-example-modules/modules/example-module
      when -> (_) { @mod.source.include?('git::') }
        @mod.name      # example-module
      else # inferred git, registry
        @mod.full_repo #  tongueroo/example-module
      end
    end

    def parent_stage_folder
      case @mod.type
      when 'local'
        'local'
      when 'http'
        'http'
      else # gcs, s3, git, registry
        @mod.vcs_provider
      end
    end

    def type_path
      source = @mod.source
      url = source.sub("#{@mod.type}::",'')
      uri = URI(url)
      uri.path.sub('/','')   # removing leading slash to bucket name is the first thing
         .sub(%r{//(.*)},'') # remove subfolder
    end

    def remove_ext(path)
      ext = File.extname(path)
      path.sub(ext,'')
    end

    def get_bucket_key(path)
      bucket, *rest = path.split('/')
      key = rest.join('/')
      [bucket, key]
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
