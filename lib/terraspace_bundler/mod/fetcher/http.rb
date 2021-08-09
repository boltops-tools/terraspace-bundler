require "nokogiri"

class TerraspaceBundler::Mod::Fetcher
  class Http < Base
    extend Memoist
    include TerraspaceBundler::Mod::Http::Concern

    # https://www.terraform.io/docs/language/modules/sources.html#http-urls
    def run
      puts "Fetcher::Http"
      # @source http://localhost:8080/modules/example/example-module.zip
      url = @mod.source
      uri = URI(url)
      path = uri.path.sub('/','')   # removing leading slash
                .sub(%r{//(.*)},'') # remove subfolder
                .sub(%/\?*/,'')

      puts "url #{url}"
      puts "path #{path}"

      resp = http_request(url)

      if resp.code.to_i == 200
        source = get_module_source(resp)
        extract_module(source)
      else
        logger.error "ERROR: Unable to lookup up module in from http endpoint: #{url}".color(:red)
        puts "resp.code #{resp.code}"
        pp resp
        exit 1
      end
    end

  private
    def extract_module(source)
      @mod = @mod.clone
      @mod.source = source

      delegator = TerraspaceBundler::Mod::Fetcher.new(@mod)
      fetcher = delegator.instance
      fetcher.run

      # cache_path = cache_path(source) # temporary path
      # puts "source #{source}"
      # puts "cache_path #{cache_path}"

      exit
    end

    def get_module_source(resp)
      header = resp['X-Terraform-Get']
      return header if header

      body = resp.body

      doc = Nokogiri::HTML(body)
      elements = doc.xpath("//meta")
      element = elements.find { |e| e.attribute('name').to_s == 'terraform-get' }
      if element
        element.attribute('content').to_s
      else
        logger.info "WARN: source for terraform-get not found in both header and body meta tag"
      end
    end
  end
end

