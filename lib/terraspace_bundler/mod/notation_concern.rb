require 'uri'

class TerraspaceBundler::Mod
  module NotationConcern
    def remove_special_notations(source)
      remove_subfolder_notation(remove_ref_notation(source))
    end

    def remove_ref_notation(source)
      source.sub(/\?.*/,'')
    end

    def remove_subfolder_notation(source)
      parts = clean_for_notation(source).split('//')
      if parts.size == 2 # has subfolder
        source.split('//')[0..-2].join('//') # remove only subfolder, keep rest of original source
      else
        source
      end
    end

    def subfolder_slash_notation(source)
      parts = clean_for_notation(source).split('//')
      if parts.size == 2 # has subfolder
        parts.last
      end
    end

    def ref_slash_notation(source)
      url = clean_for_notation(source)
      uri = URI(url)
      if uri.query
        params = URI::decode_www_form(uri.query).to_h # if you are in 2.1 or later version of Ruby
        params['ref']
      end
    end

    def clean_for_notation(source)
      source.sub(/.*::/,'').sub(%r{http[s?]://},'').sub(%r{git@(.*?):},'') # also remove git@ notation
    end
  end
end
