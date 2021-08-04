require 'net/http'
require 'open-uri'

class TerraspaceBundler::Mod
  class HttpSource
    include TB::Util::Logging

    def initialize(source, version)
      # @source, @version = source, version
    end

    def source_url
      # TODO: use http client to connect and grab the source per
      # https://www.terraform.io/docs/language/modules/sources.html#http-urls
    end
  end
end
