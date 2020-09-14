class TerraspaceBundler::CLI
  class Runner < Base
    def run
      TB::Installer.new(@options).run
    end
  end
end
