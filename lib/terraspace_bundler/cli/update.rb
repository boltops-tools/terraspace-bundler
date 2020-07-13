class TerraspaceBundler::CLI
  class Update < Base
    def run
      TB::Updater.new(@options).run
    end
  end
end
