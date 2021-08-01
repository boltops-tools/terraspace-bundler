class TerraspaceBundler::Dsl
  module Syntax
    def org(url)
      config.org = url
    end
    alias_method :user, :org

    def base_clone_url(value)
      config.base_clone_url = value
    end

    def export_to(path)
      config.export_to = path
    end

    def export_purge(value)
      config.export_purge = value
    end

    def stack_options(value={})
      config.stack_options.merge!(value)
    end

    def clone_with(value)
      config.clone_with = value
    end

    def config
      TB.config
    end

    def mod(*args, **options)
      meta[:mods] << {args: args, options: options}
    end
  end
end
