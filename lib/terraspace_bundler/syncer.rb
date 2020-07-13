module TerraspaceBundler
  class Syncer
    def initialize(mods)
      @mods = mods
    end

    def run
      @mods.each do |mod|
        mod.sync
      end
    end
  end
end
