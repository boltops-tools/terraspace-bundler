class TerraspaceBundler::CLI
  class Bundle < TerraspaceBundler::Command
    terrafile_option = Proc.new {
      option :terrafile, default: ENV['TB_TERRAFILE'] || "Terrafile", desc: "Terrafile to use"
    }

    desc "list", "List bundled modules included by Terrafile."
    long_desc Help.text("bundle/list")
    terrafile_option.call
    def list
      TB::List.new(options).run
    end

    desc "info MOD", "Provide info about a bundled module."
    long_desc Help.text("bundle/info")
    terrafile_option.call
    def info(mod)
      TB::Info.new(options.merge(mod: mod)).run
    end

    desc "install", "Install modules from the Terrafile."
    long_desc Help.text("bundle/install")
    terrafile_option.call
    def install
      TB::Runner.new(options).run
    end

    desc "purge_cache", "Purge cache."
    long_desc Help.text("bundle/purge_cache")
    def purge_cache
      PurgeCache.new(options).run
    end

    desc "update [MOD]", "Update bundled modules."
    long_desc Help.text("bundle/update")
    terrafile_option.call
    def update(*mods)
      TB::Runner.new(options.merge(mods: mods, mode: "update")).run
    end
  end
end
