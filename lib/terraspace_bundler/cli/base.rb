class TerraspaceBundler::CLI
  class Base
    include TB::Logging

    def initialize(options={})
      @options = options
    end
  end
end
