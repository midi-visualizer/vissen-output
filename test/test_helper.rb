# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'simplecov'
SimpleCov.start 'test_frameworks'

require 'vissen/output'
require 'minitest/autorun'

module Minitest
  module Assertions
    def assert_color_equal(color_a, color_b)
      assert_equal color_a.r, color_b.r
      assert_equal color_a.g, color_b.g
      assert_equal color_a.b, color_b.b
    end
  end
end
