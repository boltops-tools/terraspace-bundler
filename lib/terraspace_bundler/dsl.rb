module TerraspaceBundler
  class Dsl
    include DslEvaluator
    include Syntax

    class_attribute :meta
    self.meta = {global: {}, mods: []}

    def run
      evaluate_file(TB.config.terrafile)
      self.class.meta
    end

    def meta
      self.class.meta
    end
  end
end
