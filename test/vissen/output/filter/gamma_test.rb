# frozen_string_literal: true

require 'test_helper'

describe Vissen::Output::Filter::Gamma do
  subject { Vissen::Output::Filter::Gamma }

  let(:context) { Vissen::Output::Context::Grid.new 2, 3 }
  let(:pixel_buffer) { Vissen::Output::PixelBuffer.new context }
  let(:filter)      { subject.new context }
  let(:red)         { rand }
  let(:green)       { rand }
  let(:blue)        { rand }

  describe '.new' do
    it 'sets the default gamma value' do
      assert_equal 2.2, filter.value
    end

    it 'accepts an optional gamma value' do
      filter = subject.new context, value: 1.8
      assert_equal 1.8, filter.value
    end
  end

  describe '#apply' do
    before do
      pixel_buffer.each do |pixel|
        pixel.r = red
        pixel.g = green
        pixel.b = blue
      end
    end

    it 'changes the color gamut' do
      filter.apply pixel_buffer

      corrected_red   = red**2.2
      corrected_green = green**2.2
      corrected_blue  = blue**2.2

      pixel_buffer.each do |pixel|
        assert_in_epsilon corrected_red,   pixel.r
        assert_in_epsilon corrected_green, pixel.g
        assert_in_epsilon corrected_blue,  pixel.b
      end
    end
  end
end
