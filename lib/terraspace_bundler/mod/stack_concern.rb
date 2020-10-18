class TerraspaceBundler::Mod
  module StackConcern
    def stacks
      stacks = @props[:stacks] || @props[:stack]
      return unless stacks
      if all_stacks?(stacks)
        stacks = all_stacks
      end
      normalize_stacks(stacks)
    end
    alias_method :stack, :stacks # important to have alias for VersionCheck

    def all_stacks?(*stacks)
      stacks.flatten == [:all]
    end

    def all_stacks
      stack = TerraspaceBundler::Exporter::Stacks::Stack.new(self) # to get the mod src path
      expr = "#{stack.examples_folder}/*"
      dirs = Dir.glob(expr).select { |path| File.directory?(path) }
      dirs.map do |dir|
        example = File.basename(dir)
        # Set name so multiple app/stacks are created instead of just one app/stack/MOD
        {
          name: example,
          src: example,
        }
      end
    end

    # Normalizes stack options to an Array of Hashes or just a single Hash
    def normalize_stacks(option)
      defaults = TB.config.stack_options.dup
      result = case option
      when String
        [defaults.merge(src: option)]
      when Array
        option.map! {|s| normalize_stacks(s) }
      else # Hash
        [defaults.merge!(option)]
      end
      result.flatten
    end
  end
end
