class TerraspaceBundler::CLI
  class Base
    include TB::Util::Logging

    def initialize(options={})
      @options = options
      set_config!
    end

    def set_config!
      return unless @options[:terrafile]
      TB.config.terrafile = @options[:terrafile]
      TB.config.lockfile = "#{@options[:terrafile]}.lock"
      TB.config
    end
  end
end
