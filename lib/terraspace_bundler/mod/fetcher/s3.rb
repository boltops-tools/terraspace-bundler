require 'aws-sdk-s3'
require 'uri'

class TerraspaceBundler::Mod::Fetcher
  class S3 < Base
    extend Memoist

    def run
      response_target = stage_path(mod_relative_path)
      bucket, *rest = mod_relative_path.split('/')
      key = rest.join('/')

      url = @mod.source.sub('s3::','')
      uri = URI(url)
      region = if uri.host == 'https://s3.amazonaws.com'
                 'us-east-1'
               else
                 uri.host.match(/s3-(.*)\.amazonaws/)[1]
               end

      # Download to stage area
      FileUtils.mkdir_p(File.dirname(response_target))
      s3(region).get_object(
        response_target: response_target,
        bucket: bucket,
        key: key,
      )
    end

  private
    def s3(region)
      Aws::S3::Client.new(region: region)
    end
    memoize :s3
  end
end
