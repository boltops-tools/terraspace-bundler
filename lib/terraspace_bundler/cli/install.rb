class TerraspaceBundler::CLI
  class Install < Base
    def run
      TB::Installer.new(@options).run
    end
  end
end
