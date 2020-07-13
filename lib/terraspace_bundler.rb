$:.unshift(File.expand_path("../", __FILE__))
require "active_support/core_ext/class"
require "active_support/core_ext/hash"
require "active_support/core_ext/string"
require "active_support/ordered_options"
require "dsl_evaluator"
require "fileutils"
require "memoist"
require "rainbow/ext/string"
require "terraspace_bundler/version"
require "yaml"

require "terraspace_bundler/autoloader"
TerraspaceBundler::Autoloader.setup

DslEvaluator.backtrace_reject = "lib/terraspace_bundler"

module TerraspaceBundler
  class Error < StandardError; end
  extend Core
end

TB = TerraspaceBundler
