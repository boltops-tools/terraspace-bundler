module TerraspaceBundler::Util
  module Registry
    extend Memoist

    def registry?(url)
      !url.nil? && url.split('/').size == 3
    end

    def registry_github
      TB::Mod::Registry.new(self).to_github
    end
    memoize :registry_github

    def obtain_org(source_option, global_org=nil)
      source = registry?(source_option) ? registry_github : source_option
      parts = source.split('/') # IE: git@github.com:boltopspro/terraform-google-vm
      if parts.size == 1
        global_org
      else
        parts[-2..-2].first
      end
    end
  end
end
