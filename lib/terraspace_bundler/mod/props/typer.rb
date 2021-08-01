class TerraspaceBundler::Mod::Props
  class Typer
    delegate :source, to: :props

    attr_reader :props
    def initialize(props)
      @props = props # Props.new object
    end

    # IE: git or registry
    def type
      registry? ? "registry" : "git"
    end

    def registry?
      !source.nil? && !source.include?(':') &&
      (source.split('/').size == 3 || source.split('/').size == 4)
    end
  end
end
