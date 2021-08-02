class TerraspaceBundler::Mod::Props
  class Typer
    include TerraspaceBundler::Mod::Concerns::LocalConcern
    include TerraspaceBundler::Mod::Concerns::NotationConcern

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
      elsif source.include?('::')
        source.split('::').first # IE: git:: s3:: gcs::
      else
        "git"
      end
    end

  private
    # dont use registry? externally. instead use type since it can miss local detection
    def registry?
      if source.nil? ||
         source.starts_with?('git@') || # git@github.com:tongueroo/pet
         source.starts_with?('http') || # https://github.com/tongueroo/pet
         source.include?('::')          # git::https:://git.example.com/pet
         return false
      end
      s = remove_notations(@props.source)
      (s.split('/').size == 3 || s.split('/').size == 4)
    end
  end
end
