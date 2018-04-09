# frozen_string_literal: true

require 'test_helper'

describe Vissen::Output::Color do
  subject { Vissen::Output::Color }
  let(:components) { [0.47, 0.6, 0.23333] }
  let(:color)      { subject.new(*components) }
  let(:other)      { subject.new(0.5, 0.5, 0.5) }

  describe '.new' do
    it 'defaults to 0 values' do
      color = subject.new
      assert_equal 0.0, color.r
      assert_equal 0.0, color.g
      assert_equal 0.0, color.b
    end
  end

  describe '.from' do
    it 'accepts an array of numbers' do
      color = subject.from components

      assert_equal components[0], color.r
      assert_equal components[1], color.g
      assert_equal components[2], color.b
    end

    it 'accepts a color' do
      color = subject.from other

      assert_equal other, color
    end

    it 'accepts an integer' do
      color = subject.from 0x78993B
      delta = 0.5 / 255
      assert_in_delta components[0], color.r, delta
      assert_in_delta components[1], color.g, delta
      assert_in_delta components[2], color.b, delta
    end
  end

  describe '#to_a' do
    it 'returns an array with the three elemenets' do
      assert_equal components, color.to_a
    end
  end

  describe '#inspect' do
    it 'returns a string representation of the pixel' do
      assert_equal '#78993B', color.inspect
    end
  end

  describe '#mix_with!' do
    it 'leaves the color unchanged when ratio = 0' do
      color.mix_with!(other, 0)
      assert_equal components, color.to_a
    end

    it 'turns into the other color when ratio = 1' do
      color.mix_with!(other, 1)
      assert_equal other.to_a, color.to_a
    end

    it 'mixes the two color' do
      color.mix_with!(other, 0.5)
      assert_in_epsilon (0.5 + 0.47) / 2, color.r
      assert_in_epsilon (0.5 + 0.6) / 2, color.g
      assert_in_epsilon (0.5 + 0.23333) / 2, color.b
    end
  end
end
