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

    def run
      @changed = false
      strict_versions = %w[subfolder ref tag export_to]
      strict_versions.each do |version|
        @changed = @locked.send(version) != @current.send(version)
        if @changed
          @reason = reason_message(version)
          return @changed
        end
      end

      # Loose version checks work a little different. If not set it explicitly, they will not be checked.
      # Will use locked version in Terrafile.lock in this case.
      # Note: Also, check the sha last since it triggers a git fetch.
      loose_versions = %w[branch sha]
      loose_versions.each do |version|
        @changed = @current.send(version) && @current.send(version) != @locked.send(version)
        if @changed
          @reason = reason_message(version)
          return @changed
        end
      end

      @changed
    end

    def reason_message(version)
      "Replacing mod: #{@current.name}. #{version} is different in Terrafile and Terrafile.lock"
    end
  end
end
