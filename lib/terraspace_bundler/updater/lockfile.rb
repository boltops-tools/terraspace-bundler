require "yaml"

class TerraspaceBundler::Updater
  class Lockfile
    include TB::Logging

    def initialize(mods=[])
      @mods = mods
    end

    def create
      data = {}
      @mods.each do |mod|
        data.merge!(item(mod))
      end
      write(data)
    end

    def item(mod)
      props = {
        path: mod.path,
        sha: mod.sha,
        source: mod.source,
        url: mod.url,
        version: mod.version,
      }
      props.delete_if { |k,v| v.nil? }
      { mod.name => props }
    end

    def update_one(mod)
      data = YAML.load_file(lockfile)
      data.merge!(item(mod))
      write(data, ": #{mod.name}")
    end

    def write(data, message="")
      content = YAML.dump(data.deep_stringify_keys)
      action = File.exist?(lockfile) ? "Updated" : "Created"
      IO.write(lockfile, content)
      logger.info "#{action} #{lockfile}#{message}"
    end

    def lockfile
      TB.config.lockfile
    end
  end
end
