module TerraspaceBundler::Util
  module NormalizeVersion
    def normalize_version(version)
      return unless version
      # remove leading v. IE: v1.0.0 => 1.0.0
      version = version.sub(/^v(\d+\.)/, '\1')
      # looks like sha https://stackoverflow.com/questions/468370/a-regex-to-match-a-sha1
      if version =~ /\b[0-9a-f]{40}\b/
        version[0..6]
      else
        version
      end
    end
  end
end
