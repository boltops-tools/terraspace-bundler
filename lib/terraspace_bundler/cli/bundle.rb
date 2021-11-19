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
    option :yes, aliases: :y, type: :boolean, desc: "bypass are you sure prompt"
    def purge_cache
      PurgeCache.new(options).run
    end

    desc "update [MOD]", "Update bundled modules."
    long_desc Help.text("bundle/update")
    terrafile_option.call
    def update(*mods)
      TB.update_mode = true
      TB::Runner.new(options.merge(mods: mods)).run
    end

    desc "example MOD EXAMPLE", "Import example from module as a stack"
    long_desc Help.text("bundle/example")
    terrafile_option.call
    option :name, desc: "The stack name. IE: app/stacks/NAME. By default, the mod's name is used.	"
    option :dest, default: "app/stacks", desc: "The default destination folder is app/stacks. Though you can change it to locations like vendor/stacks, it’s recommended to keep the default."
    option :purge, type: :boolean, default: true, desc: "If set to `true`, then the existing `app/stacks/vpc` folder is removed."
    def example(mod, example)
      TB::Example.new(options.merge(mod: mod, example: example)).run
    end
  end
end
