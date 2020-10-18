class TerraspaceBundler::Exporter::Stacks
  class Rewrite < Base
    def initialize(stack)
      @stack = stack
    end

    def run
      expr = "#{@stack.dest}/*.tf"
      Dir.glob(expr).each do |path|
        next unless File.file?(path) # skip symlinks and dirs
        replace(path)
      end
    end

    def replace(path)
      lines = IO.readlines(path)
      new_lines = new_lines(lines)
      text = new_lines.join('')
      IO.write(path, text)
    end

    def new_lines(lines)
      lines.map do |line|
        # leading spaces or no space. but cannot have any other chars
        # can have space betweens source and =
        line =~ /^\s*source\s*=/ ? new_line(line) : line
      end
    end

    def new_line(line)
      # marker comment so files dont get updated twice when purge is false
      terraspace_comment = "# updated by terraspace"
      return line unless line.include?("../")
      return line if line.include?(terraspace_comment)

      md = line.match(/^\s*source\s*=\s*"(.*)?"/)
      unless md
        logger.error "ERROR: unable to find the module source".color(:red)
        logger.error line
        exit 1
      end
      # Lots of cases covered by specs
      #
      #     ../..
      #     ../../
      #     ../../modules/iam-user
      #     ../../../modules/compute_instance
      #
      source_value = md[1] # IE: ""../../../modules/compute_instance"
      dirs = source_value.split('/')
      count = dirs.count('..')
      mod_dir = dirs[count..-1].join('/')
      full_dir = [@stack.mod.name, mod_dir].reject(&:empty?).join('/')
      %Q|  source = "../../modules/#{full_dir}" #{terraspace_comment}\n|
    end
  end
end
