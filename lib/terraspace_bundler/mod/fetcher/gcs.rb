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
      file = bucket.file(key)
      unless file
        logger.error "ERROR: Unable to find gs://#{bucket_name}/#{key}".color(:red)
        exit 1
      end

      archive = cache_path(path) # temporary path
      logger.debug "Gcs save archive to #{archive}"
      FileUtils.mkdir_p(File.dirname(archive))
      file.download(archive)

      # Save to stage
      dest = stage_path(rel_dest_dir)
      extract(archive, dest)
    end

  private
    def gcs_info
      path = type_path
      path.sub!(%r{storage/v\d+/},'')
      bucket, key = get_bucket_key(path)
      [bucket, key, path]
    end

    def storage
      Google::Cloud::Storage.new
    end
    memoize :storage
  end
end
