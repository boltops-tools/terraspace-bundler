require "google/cloud/storage"

class TerraspaceBundler::Mod::Fetcher
  class Gcs < Base
    extend Memoist

    def run
      bucket, key, path = gcs_info
      download(bucket, key, path)
    end

    def download(bucket_name, key, path)
      # Download to cache area
      bucket = storage.bucket(bucket_name)
      unless bucket
        logger.error "ERROR: bucket #{bucket_name} does not exist".color(:red)
        exit 1
      end
      puts "bucket #{bucket}"
      puts "bucket_name #{bucket_name}"
      puts "key #{key}"
      file = bucket.file(key)
      unless file
        logger.error "ERROR: Unable to find gs://#{bucket_name}/#{key}".color(:red)
        exit 1
      end

      archive = cache_path(path) # temporary path
      logger.debug "Gcs download archive to: #{archive}"
      FileUtils.mkdir_p(File.dirname(archive))
      file.download(archive)

      # Save to stage
      dest = stage_path(rel_dest_dir)
      puts "archive #{archive}"
      puts "dest #{dest}"
      extract(archive, dest)
    end

  private
    def gcs_info
      source = @mod.source
      url = source.sub('gcs::','')
      uri = URI(url)
      path = uri.path.sub('/','') # removing leading slash, includes bucket name. and remove subfolder
      md = path.match(%r{//(.*)})
      subfolder = md[1] if md
      path.sub!("//#{subfolder}",'')
      path.sub!(%r{storage/v\d+/},'')
      puts "path #{path}"
      bucket, *rest = path.split('/')
      key = rest.join('/')
      [bucket, key, path]
    end

    def storage
      Google::Cloud::Storage.new
    end
    memoize :storage
  end
end
