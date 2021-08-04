module TerraspaceBundler
  class Extract
    def self.extract(archive, dest)
      FileUtils.rm_rf(dest)
      FileUtils.mkdir_p(File.dirname(dest))

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
