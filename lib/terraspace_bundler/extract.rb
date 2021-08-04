module TerraspaceBundler
  class Extract
    def self.extract(archive, dest)
      if archive.ends_with?('.tgz') || archive.ends_with?('.tar.gz')
        Tar.extract(archive, dest)
      elsif archive.ends_with?('.zip')
        Zip.extract(archive, dest)
      else
        raise "Unable to extract. Unknown archive extension for #{archive}."
      end
    end
  end
end
