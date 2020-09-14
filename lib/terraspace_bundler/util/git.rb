module TerraspaceBundler::Util
  module Git
    include TB::Util::Logging

    def sh(command)
      command = "#{command} 2>&1" # always need output for the sha
      logger.debug "=> #{command}"
      out = `#{command}`
      unless $?.success?
        if command.include?("git")
          raise TB::GitError.new("#{command}\n#{out}")
        else
          logger.error "ERROR: running #{command}".color(:red)
          logger.error out
          exit $?.exitstatus
        end
      end
      out
    end

    def git(command)
      sh("git #{command}")
    rescue TB::GitError => e
      logger.error "ERROR: There was a git error".color(:red)
      logger.error "Current dir: #{Dir.pwd}"
      logger.error "The error occur when running:"
      logger.error e.message
      exit 1
    end
  end
end
