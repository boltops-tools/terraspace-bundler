require "yaml"

module TerraspaceBundler
  class Lockfile
    include Singleton
    include TB::Util::Logging

    # {"vpc"=>
    #   {"sha"=>"52328b2b5197f9b95e3005cfcfb99595040ee45b",
    #   "source"=>"org/terraform-aws-vpc",
    #   "url"=>"git@github.com:org/terraform-aws-vpc"},
    # "instance"=>
    #   {"sha"=>"570cca3ea7b25e3af1961dc57b27ca2c129b934a",
    #   "source"=>"org/terraform-aws-instance",
    #   "url"=>"git@github.com:org/terraform-aws-instance"}}
    @@mods = nil
    def mods
      return @@mods if @@mods
      lockfile = TB.config.lockfile
      mods = File.exist?(lockfile) ? YAML.load_file(lockfile) : []
      @@mods = mods.map do |name, props|
        new_mod(name, props)
      end
    end

    def new_mod(name, props)
      Mod.new(props.merge(name: name))
    end

    # update (if version mismatch) or create (if missing)
    def sync(mod)
      changed = changed?(mod)
      logger.debug "Detecting change for mod #{mod.name} changed #{changed.inspect}"
      replace!(mod) if changed
    end

    # mod built from Terrafile
    def changed?(mod)
      # missing module case
      found = mods.find { |locked_mod| locked_mod.name == mod.name }
      unless found
        logger.debug "Replacing mod: #{mod.name}. Not found in Terrafile.lock"
        return true
      end

      comparer = VersionComparer.new(found, mod)
      comparer.run
      logger.debug(comparer.reason) if comparer.reason
      comparer.changed?
    end

    def replace!(mod)
      # mods are immediately fresh from writing to @@mods directly
      @@mods.delete_if { |m| m.name == mod.name }
      @@mods << mod
      @@mods.sort_by!(&:name)
    end

    def prune(removed_mods)
      removals = removed_mods.map(&:name)
      @@mods.delete_if { |m| removals.include?(m.name) }
    end

    class << self
      def write
        Yamler.write(@@mods) if @@mods
      end
    end
  end
end
