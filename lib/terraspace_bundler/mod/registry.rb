require 'net/http'
require 'open-uri'

class TerraspaceBundler::Mod
  class Registry
    def initialize(source, version)
      @source, @version = source, version
    end

    # Terrafile example
    #
    #      mod "sg", source: "terraform-aws-modules/security-group/aws", version: "3.10.0"
    #
    # Resources: https://www.terraform.io/docs/registry/api.html
    #
    # Latest version:
    #
    #     https://registry.terraform.io/v1/modules/terraform-aws-modules/sqs/aws/2.1.0/download
    #
    # The latest version returns an 302 and contains a location header that is followed
    # and then downloaded the same way the specific version is downloaded.
    #
    # Specific version:
    #
    #     https://registry.terraform.io/v1/modules/terraform-aws-modules/sqs/aws/download
    #
    # The specific version returns an 204 and then we grab the download url info form the x-terraform-get header.
    def github_url
      base_site = "https://registry.terraform.io"
      base_url = "#{base_site}/v1/modules"

      version = @version.sub(/^v/,'') if @version # v1.0 => 1.0
      api_url = [base_url, @source, version, "download"].compact.join('/')
      resp = http_request(api_url)

      case resp.code.to_i
      when 204
        download_url = resp.header["x-terraform-get"]
      when 302
        next_url = "#{base_site}#{resp.header["location"]}"
        resp = http_request(next_url)
        download_url = resp.header["x-terraform-get"]
      else
        raise "Unable to lookup up module in Terraform Registry: #{resp}"
      end

      url = download_url.sub(%r{/archive/.*},'')
      # IE: git::https://github.com/terraform-aws-modules/terraform-aws-security-group?ref=v3.10.0
      url.sub(/^git::/,'').sub(/\?.*/,'')
    end

  private
    def http_request(url)
      uri = URI(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == "https"
      # Total time will be 40s = 20 x 2
      http.max_retries = 1 # Default is already 1, just  being explicit
      http.read_timeout = 20 # Sites that dont return in 20 seconds are considered down
      request = Net::HTTP::Get.new(uri)
      begin
         http.request(request) # response
      rescue Net::OpenTimeout => e # internal ELB but VPC is not configured for Lambda function
        http_request_error_message(e)
        puts "The Lambda Function does not seem to have network access to the url. It might not be configured with a VpcConfig.  Please double check that the related vpc variables are configured: @subnet_ids, @vpc_id, @security_group_ingress"
      rescue Exception => e
        # Net::ReadTimeout - too slow
        # Errno::ECONNREFUSED - completely down
        # SocketError - improper url "dsfjsl" instead of example.com
        http_request_error_message(e)
      end
    end
  end
end
