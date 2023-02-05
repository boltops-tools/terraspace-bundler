require 'cli-format'
CliFormat.default_format = "table"

module TerraspaceBundler
  class Outdated < TB::CLI::Base
    include Util::NormalizeVersion

    def run
      file = TB.config.lockfile
      unless File.exist?(file)
        $stderr.puts "No #{file} found".color(:red)
        $stderr.puts "Maybe first run: terraspace bundle"
        return
      end

      # outdated? used to filter out only supported fetchers
      # IE: git support, s3 not supported
      mods = lockfile.mods.select(&:outdated?)
      if mods.empty?
        $stderr.puts "All modules up to date".color(:green)
        return
      end

      $stderr.puts "Outdated modules:"
      presenter = CliFormat::Presenter.new(@options)
      presenter.header = ["Name", "Current", "Latest"]
      mods.each do |mod|
        commits_ahead = pluralize(mod.commits_ahead, "commit")
        direction = mod.commits_ahead > 0 ? "ahead" : "behind"
        row = [
          mod.name,
          normalize_version(mod.current_version),
          "#{normalize_version(mod.latest_version)} (#{commits_ahead} #{direction})",
        ]
        presenter.rows << row
      end
      presenter.show
    end

    def pluralize(count, word)
      c = count.to_i.abs
      text = c == 1 ? word : "#{word}s"
      "#{c} #{text}"
    end

    def lockfile
      Lockfile.instance
    end
  end
end
