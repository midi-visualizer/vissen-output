# frozen_string_literal: true

require 'test_helper'

describe Vissen::Output::Filter::Quantizer do
  subject { Vissen::Output::Filter::Quantizer }

  let(:context)     { Vissen::Output::Context::Grid.new 2, 3 }
  let(:pixel_cloud) { Vissen::Output::PixelCloud.new context }
  let(:filter)      { subject.new context }
  let(:red)         { rand }
  let(:green)       { rand }
  let(:blue)        { rand }

  describe '.new' do
    it 'raises a RangeError when the number of steps are less than 2' do
      assert_raises(RangeError) { subject.new context, steps: 1 }
    end

    it 'raises an ArgumentError when given an exclusive range of floats' do
      assert_raises(ArgumentError) { subject.new context, range: 0.0...2.0 }
    end
  end

  describe '#apply' do
    before do
      pixel_cloud.each do |pixel|
        pixel.r = red
        pixel.g = green
        pixel.b = blue
      end
    end

    it 'discretizes the values' do
      filter.apply pixel_cloud

      discrete_red   = (red * 255).round
      discrete_green = (green * 255).round
      discrete_blue  = (blue * 255).round

      pixel_cloud.each do |pixel|
        assert_equal discrete_red,   pixel.r
        assert_equal discrete_green, pixel.g
        assert_equal discrete_blue,  pixel.b
      end
    end

    it 'scales and quantizes the values to fit a range' do
      filter = subject.new context, steps: 2, range: (1..3)
      filter.apply pixel_cloud

      assert_equal (2 * red.round + 1),   pixel_cloud.pixels[0].r
      assert_equal (2 * green.round + 1), pixel_cloud.pixels[0].g
      assert_equal (2 * blue.round + 1),  pixel_cloud.pixels[0].b
    end
  end
end
