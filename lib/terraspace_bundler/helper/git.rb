module TerraspaceBundler::Helper
  module Git
    include TB::Logging

    def sh(command)
      command = "#{command} 2>&1" # always need output for the sha
      logger.debug "=> #{command}"
      out = `#{command}`
      unless $?.success?
        logger.error "ERROR: running #{command}"
        logger.error out
        exit $?.exitstatus
      end
      out
    end

    def git(command)
      sh("git #{command}")
    end
  end
end
