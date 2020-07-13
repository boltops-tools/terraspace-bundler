class TerraspaceBundler::Dsl
  module Syntax
    def org(url)
      global[:org] = url
    end
    alias_method :user, :org

    def export_path(path)
      global[:export_path] = path
    end

    def mod(*args, **options)
      meta[:mods] << {args: args, options: options}
    end

    def global
      meta[:global]
    end
  end
end
