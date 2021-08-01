require 'net/http'
require 'open-uri'

class TerraspaceBundler::Mod
  class Registry
    include TB::Util::Logging

    def initialize(source, version)
      @source, @version = source, version
    end

    def github_url
      if @source.split('/').size > 3 # IE: app.terraform.io/demo-qa/s3-webapp/aws
        private_github_url
      else # assume size is 3. IE: terraform-aws-modules/security-group/aws
        public_github_url
      end
    end

    # https://www.terraform.io/docs/cloud/api/modules.html#get-a-module
    # GET /organizations/:organization_name/registry-modules/:registry_name/:namespace/:name/:provider
    # GET /organizations/demo-qa/registry-modules/private/demo-qa/s3-webapp/aws
    #
    #   :organization_name	The name of the organization the module belongs to.
    #   :namespace	        The namespace of the module. For private modules this is the name of the organization that owns the module.
    #   :name	              The module name.
    #   :provider	          The module provider.
    #   :registry-name	    Either public or private.
    #
    # Example: app.terraform.io/demo-qa/s3-webapp/aws
    #
    #   domain: app.terraform.io (private registry indicator)
    #   org: demo-qa
    #   module: s3-webapp
    #   provider: aws
    #
    def private_github_url
      domain, org, name, provider = @source.split('/')
      registry_name = 'private'
      namespace = org

      base_site = "https://#{domain}" # IE: domain = 'app.terraform.io'
      base_url = "#{base_site}/api/v2"
      api_url = "#{base_url}/organizations/#{org}/registry-modules/#{registry_name}/#{namespace}/#{name}/#{provider}"

      resp = http_request(api_url, auth_domain: domain)

      repo_url = case resp.code.to_i
      when 200
        result = JSON.load(resp.body)
        result['data']['attributes']['vcs-repo']['repository-http-url'] # repo_url
      when 401
        auth_error_exit!(resp)
      else
        logger.error "ERROR: Unable to lookup up module in Terraform Registry: #{@source}".color(:red)
        puts "resp.code #{resp.code}"
        pp resp
        exit 1
      end

      clone_with = 'git' # TODO: make configurable
      unless clone_with == 'https'
        repo_url.sub!('https://github.com/', 'git@github.com:')
      end

      repo_url
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
    def public_github_url
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
        logger.error "ERROR: Unable to lookup up module in Terraform Registry: #{@source}".color(:red)
        puts "resp.code #{resp.code}"
        pp resp
        exit 1
      end

      url = download_url.sub(%r{/archive/.*},'')
      # IE: git::https://github.com/terraform-aws-modules/terraform-aws-security-group?ref=v3.10.0
      url.sub(/^git::/,'').sub(/\?.*/,'')
    end

  private
    def auth_error_exit!(resp=nil, domain=nil)
      logger.error <<~EOL.color(:red)
        ERROR: Unauthorized. Unable to lookup up module in Terraform Registry:

            #{@source}

        Try logging in with:

            terraform login #{domain}

      EOL
      if resp
        puts "resp.code #{resp.code}"
        pp resp
      end
      exit 1
    end

    def http_request(url, auth_domain: nil)
      uri = URI(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == "https"
      # Total time will be 40s = 20 x 2
      http.max_retries = 1 # Default is already 1, just  being explicit
      http.read_timeout = 20 # Sites that dont return in 20 seconds are considered down
      request = Net::HTTP::Get.new(uri)

      if auth_domain
        path = "#{ENV['HOME']}/.terraform.d/credentials.tfrc.json"
        if File.exist?(path)
          data = JSON.load(IO.read(path))
          token = data['credentials'][auth_domain]['token']
          request.add_field 'Authorization', "Bearer #{token}"
        else
          auth_error_exit!
        end
      end

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
