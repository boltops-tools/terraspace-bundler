$:.unshift(File.expand_path("../", __FILE__))
require "active_support"
require "active_support/core_ext/class"
require "active_support/core_ext/hash"
require "active_support/core_ext/string"
require "active_support/ordered_options"
require "cli-format"
require "dsl_evaluator"
require "fileutils"
require "json"
require "memoist"
require "rainbow/ext/string"
require "singleton"
require "terraspace_bundler/version"
require "yaml"

require "terraspace_bundler/autoloader"
TerraspaceBundler::Autoloader.setup

DslEvaluator.backtrace_reject = "lib/terraspace_bundler"

module TerraspaceBundler
  class Error < StandardError; end
  class GitError < Error; end
  extend Core
end

TB = TerraspaceBundler
