$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "csdl"

require "minitest/pride" unless ENV.key?("NOCOLOR")
require "minitest/autorun"
require "mocha/mini_test"
