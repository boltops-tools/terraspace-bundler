class TerraspaceBundler::Exporter::Stacks
  class Stack < Base
    attr_reader :mod
    def initialize(mod, options={})
      @mod, @options = mod, options
    end

    def export
      copy
      rewrite
    end

    def copy
      return unless @options

      FileUtils.rm_rf(dest) if purge?
      return if File.exist?(dest)

      FileUtils.mkdir_p(File.dirname(dest))
      FileUtils.cp_r(src, dest)
    end

    def rewrite
      Rewrite.new(self).run
    end

    def src
      src = @options[:src]
      without_examples = [mod_path, src].compact.join('/')
      with_examples = [examples_folder, src].compact.join('/')
      paths = [with_examples, without_examples]
      found = paths.find do |path|
        File.exist?(path)
      end

      unless found
        searched = paths.map { |p| pretty_path(p) }.map { |p| "    #{p}" }.join("\n")
        logger.error "ERROR: Example not found. stack src: #{src}. Searched:".color(:red)
        logger.error searched
        exit 1
      end
      found
    end

    def pretty_path(path)
      path.sub("#{Dir.pwd}/",'')
    end

    # public method used by StackConcern#all_stacks
    def examples_folder
      [mod_path, examples].join('/')
    end

    def examples
      @options[:examples] || TB.config.stack_options[:examples]
    end

    def dest
      dest = @options[:dest] || TB.config.stack_options[:dest]
      name = @options[:name] || @mod.name # falls back to mod name by default
      "#{dest}/#{name}"
    end

    # purge precedence:
    #
    #     1. Terrafile mod level stack option
    #     2. Terrafile-level stack_options
    #
    def purge?
      # config.stack_options is set from Terrafile-level stack_options to TB.config.stack
      # relevant source code: dsl/syntax.rb: def stack_options
      config = TB.config.stack_options[:purge]
      config = config.nil? ? false : config
      @options[:purge].nil? ? config : @options[:purge]
    end
  end
end
