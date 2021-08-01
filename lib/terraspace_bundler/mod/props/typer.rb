class TerraspaceBundler::Mod::Props
  class Typer
    include TerraspaceBundler::Mod::LocalConcern

    delegate :source, to: :props

    attr_reader :props
    def initialize(props)
      @props = props # Props.new object
    end

    # IE: git or registry
    def type
      if local?
        "local"
      elsif registry?
        "registry"
      else
        "git"
      end
    end

  private
    # dont use registry? externally. instead use type since it can miss local detection
    def registry?
      s = @props.source_without_subfolder
      !s.nil? && !s.include?(':') &&
      (!s.include?('git@') || !s.include?('http')) &&
      (s.split('/').size == 3 || s.split('/').size == 4)
    end
  end
end
