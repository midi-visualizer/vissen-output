# frozen_string_literal: true

require 'test_helper'

describe Vissen::Output::Pixel do
  subject { Vissen::Output::Pixel }
  let(:components) { [0.47, 0.6, 0.23333] }
  let(:pixel)      { subject.new(*components) }

  describe '.new' do
    it 'defaults to 0 values' do
      pixel = subject.new
      assert_equal 0.0, pixel.r
      assert_equal 0.0, pixel.g
      assert_equal 0.0, pixel.b
    end
  end

  describe '#to_a' do
    it 'returns an array with the three elemenets' do
      assert_equal components, pixel.to_a
    end
  end

  describe '#clear!' do
    it 'clears the values' do
      pixel.clear!
      assert_equal 0.0, pixel.r
      assert_equal 0.0, pixel.g
      assert_equal 0.0, pixel.b
    end
  end

  describe '#inspect' do
    it 'returns a string representation of the pixel' do
      assert_equal '(0.5, 0.6, 0.2)', pixel.inspect
    end
  end
end
