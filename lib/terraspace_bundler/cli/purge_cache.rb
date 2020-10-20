class TerraspaceBundler::CLI
  class PurgeCache < Base
    include TB::Mod::PathConcern
    include TB::Util::Logging
    include TB::Util::Sure

    def run
      paths = [tmp_root]
      are_you_sure?(paths)
      paths.each do |path|
        FileUtils.rm_rf(path)
        logger.info "Removed #{path}"
      end

    end

    def are_you_sure?(paths)
      pretty_paths = paths.map { |p| "    #{p}" }.join("\n")
      message = <<~EOL.chomp
        Will remove these folders and all their files:

        #{pretty_paths}

        Are you sure?
      EOL
      sure?(message) # from Util::Sure
    end
  end
end
