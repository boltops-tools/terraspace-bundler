class TerraspaceBundler::Lockfile
  class VersionComparer
    attr_reader :reason, :changed
    def initialize(locked, current)
      @locked, @current = locked, current
      @changed = false
    end

    def changed?
      @changed
    end

    # Tricky logic, maybe spec this.
    #
    #   no mods specified:
    #     terraspace bundle update  # no mods specified => update all
    #     terraspace bundle install # no Terrafile.lock => update all
    #   mods specified:
    #     terraspace bundle update s3  # explicit mod => update s3
    #     terraspace bundle install s3 # errors: not possible to specify module for install command
    #
    # Note: Install with specific mods wipes existing mods. Not worth it to support.
    #
    def run
      @changed = false

      # Most props are "strict" version checks. So if user changes options generally in the mod line
      # the Terrafile.lock will get updated, which is expected behavior.
      props = @locked.props.keys + @current.props.keys
      strict_versions = props.uniq.sort - [:sha]
      strict_versions.each do |version|
        @changed = @locked.send(version) != @current.send(version)
        if @changed
          @reason = reason_message(version)
          return @changed
        end
      end

      # Lots of nuance with the sha check that works differently
      # Only check when set.
      # Also in update mode then always check it.
      @changed = @current.sha && !@locked.sha.include?(@current.sha) ||
                 update_mode? && !@current.latest_sha.include?(@locked.sha)
      if @changed
        @reason = reason_message("sha")
        return @changed
      end

      @changed
    end

    def reason_message(version)
      "Replacing mod #{@current.name} because #{version} is different in Terrafile and Terrafile.lock"
    end

    def update_mode?
      self.class.update_mode
    end

    class_attribute :update_mode
  end
end
