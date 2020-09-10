module TerraspaceBundler
  class Dsl
    include DslEvaluator
    include Syntax

    class_attribute :meta, default: {global: {}, mods: []}

    def run
      evaluate_file(TB.config.terrafile)
      self
    end

    def meta
      self.class.meta
    end

    def global
      meta[:global]
    end
  end
end
