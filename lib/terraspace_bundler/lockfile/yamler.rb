require "yaml"

class TerraspaceBundler::Lockfile
  class Yamler
    def initialize(mods)
      @mods = mods.sort_by(&:name)
    end

    def dump
      YAML.dump(data.deep_stringify_keys)
    end

    def data
      @mods.inject({}) do |acc, mod|
        acc.merge(item(mod))
      end
    end

    def item(mod)
      props = mod.props.dup # passthrough: name, url, version, ref, tag, branch etc
      props.delete(:name) # different structure in Terrafile.lock YAML
      props[:sha] ||= mod.latest_sha
      props.delete_if { |k,v| v.nil? }
      { mod.name => props }
    end

    def write
      IO.write(TB.config.lockfile, dump)
    end

    class << self
      def write(mods)
        new(mods).write
      end
    end
  end
end
