# frozen_string_literal: true

require 'test_helper'

describe Vissen::Output::Point do
  subject { Vissen::Output::Point }
  let(:x)     { rand }
  let(:y)     { rand }
  let(:point) { subject.new(x, y) }

  describe '.from' do
    it 'accepts an array of coordinates' do
      point = subject.from [x, y]

      assert_equal x, point.x
      assert_equal y, point.y
    end

    it 'accepts a point' do
      new_point = subject.from point

      assert_equal point.x, new_point.x
      assert_equal point.y, new_point.y
    end
  end

  describe '#freeze' do
    it 'freezes the object' do
      point.freeze
      assert point.frozen?
    end

    it 'freezes the position' do
      point.freeze
      assert point.position.frozen?
    end
  end

  describe '#inspect' do
    it 'returns a string representation of the point' do
      point = subject.new 0.4, 0.789
      assert_equal '(0.40,0.79)', point.inspect
    end
  end

  describe '#position' do
    it 'returns the x an y coordinates' do
      assert_equal [x, y], point.position
    end
  end

  describe '#to_a' do
    it 'is an alias of #position' do
      assert_equal point.method(:position), point.method(:to_a)
    end
  end
end
