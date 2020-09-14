class TerraspaceBundler::Logger
  class Formatter < ::Logger::Formatter
    def call(severity, time, progname, msg)
      msg =~ /\n$/ ? msg : "#{msg}\n"
    end
  end
end
