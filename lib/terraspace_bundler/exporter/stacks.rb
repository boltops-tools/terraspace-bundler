class TerraspaceBundler::Exporter
  class Stacks < Base
    def initialize(mod)
      @mod = mod
      @stacks = mod.stacks || []
    end

    def export
      @stacks.each do |options|
        Stack.new(@mod, options).export
      end
    end
  end
end
