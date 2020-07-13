class TerraspaceBundler::CLI
  class Bundle < TerraspaceBundler::Command
    terrafile_option = Proc.new {
      option :terrafile, default: "Terrafile", desc: "Terrafile to use"
    }

    desc "install", "install"
    long_desc Help.text("bundle/install")
    terrafile_option.call
    def install
      Install.new(options).run
    end

    desc "update", "update"
    long_desc Help.text("bundle/install")
    terrafile_option.call
    def update(mod=nil)
      Update.new(options.merge(mod: mod)).run
    end

    desc "clean", "clean"
    long_desc Help.text("bundle/clean")
    def clean
      Clean.new(options).run
    end
  end
end
