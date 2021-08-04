require 'aws-sdk-s3'
require 'uri'

class TerraspaceBundler::Mod::Fetcher
  class S3 < Base
    extend Memoist

    def run
      region, bucket, key, path = s3_info

      # Download to cache area
      response_target = cache_path(path) # temporary path

      unless File.exist?(response_target)
        logger.debug "S3 saving to #{response_target}".color(:yellow)
        FileUtils.mkdir_p(File.dirname(response_target))
        s3(region).get_object(
          response_target: response_target,
          bucket: bucket,
          key: key,
        )
      end

      # Save to stage
      dest = stage_path(relative_dest_dir)
      extract(response_target, dest)
    end

  private
    def s3_info
      source = @mod.source
      url = source.sub('s3::','')
      uri = URI(url)
      path = uri.path.sub('/','') # removing leading slash, includes bucket name. and remove subfolder
      md = path.match(%r{//(.*)})
      subfolder = md[1] if md
      path = path.sub("//#{subfolder}",'')
      bucket, *rest = path.split('/')
      key = rest.join('/')

      url = @mod.source.sub('s3::','')
      uri = URI(url)
      region = if uri.host == 'https://s3.amazonaws.com'
                 'us-east-1'
               else
                 uri.host.match(/s3-(.*)\.amazonaws/)[1]
               end

      [region, bucket, key, path]
    end

    def extract(archive, dest)
      TerraspaceBundler::Extract.extract(archive, dest)
    end

    def s3(region)
      Aws::S3::Client.new(region: region)
    end
    memoize :s3
  end
end
