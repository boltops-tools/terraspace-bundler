require 'aws-sdk-s3'
require 'uri'

class TerraspaceBundler::Mod::Fetcher
  class S3 < Base
    extend Memoist

    def run
      source = @mod.source
      # s3::https://s3-us-west-2.amazonaws.com/demo-terraform-test/example-module.zip

      url = source.sub('s3::','')
      uri = URI(url)
      region = if uri.host == 'https://s3.amazonaws.com'
                 'us-east-1'
               else
                 uri.host.match(/s3-(.*)\.amazonaws/)[1]
               end
      bucket, *rest = uri.path.sub('/','').split('/') # remove starting slash and split
      key = rest.join('/')

      stage = stage_path(key)
      FileUtils.rm_rf(dest)
      FileUtils.mkdir_p(File.dirname(dest))

      # Download to stage area first in case s3 permission fails
      resp = s3(region).get_object(
        response_target: stage,
        bucket: bucket,
        key: key,
      )

      pp resp

      puts "region #{region}"
      puts "bucket #{bucket}"
      puts "key #{key}"
      # dest /tmp/terraspace/bundler/stage/s3-us-west-2.amazonaws.com/modules/example-module.zip

      exit 1
      # puts "@mod.stage_relative_path #{@mod.stage_relative_path}"
      # source = @mod.source
      # src = source.sub(/^~/, ENV['HOME']) # allow ~/ notation
    end

  private
    def s3(region)
      Aws::S3::Client.new(region: region)
    end
    memoize :s3
  end
end
