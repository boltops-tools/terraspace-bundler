require 'net/http'
require 'open-uri'

module TerraspaceBundler::Mod::Http
  class Source
    include TB::Util::Logging
    include Concern

    def initialize(params)
      @params = params
      @options = params[:options]
      @source = @options[:source]
    end

    def url
      @source
    end
  end
end
