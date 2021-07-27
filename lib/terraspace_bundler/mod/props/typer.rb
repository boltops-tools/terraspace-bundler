class TerraspaceBundler::Mod::Props
  class Typer
    def initialize(props)
      @props = props # Props.new object
    end

    def detect
      registry? ? "registry" : "git"
    end

    def registry?
      !source.nil? && !source.include?(':') && source.split('/').size == 3
    end

    def source
      @props.source
    end
  end
end

