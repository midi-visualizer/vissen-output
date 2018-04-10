# frozen_string_literal: true

require 'test_helper'

class ContextMock
  include Vissen::Output::Context
end

describe Vissen::Output::Context do
  subject { ContextMock }

  let(:width)   { 10.0 }
  let(:height)  { 5.0 }
  let(:context) { subject.new width, height }

  describe '.new' do
    it 'normalizes width and height when width > height' do
      assert_in_epsilon 1.0, context.width
      assert_in_epsilon 0.5, context.height
      refute context.one_dimensional?
    end

    it 'normalizes width and height when width < height' do
      context = subject.new height, width
      assert_in_epsilon 0.5, context.width
      assert_in_epsilon 1.0, context.height
      refute context.one_dimensional?
    end

    it 'allows the width to be 0' do
      context = subject.new 0, height

      assert_in_epsilon 0.0, context.width
      assert_in_epsilon 1.0, context.height
      assert context.one_dimensional?
    end

    it 'allows the height to be 0' do
      context = subject.new width, 0

      assert_in_epsilon 1.0, context.width
      assert_in_epsilon 0.0, context.height
      assert context.one_dimensional?
    end

    it 'raises a RangeError when width < 0' do
      assert_raises(RangeError) do
        subject.new(-1, height)
      end
    end

    it 'raises a RangeError when height < 0' do
      assert_raises(RangeError) do
        subject.new(width, -1)
      end
    end

    it 'raises a RangeError when both dimensions are 0' do
      assert_raises(RangeError) do
        subject.new 0, 0
      end
    end
  end

  describe '#point_count' do
    it 'raises an exception when not implemented' do
      assert_raises(NotImplementedError) { context.point_count }
    end
  end

  describe 'point_count dependent methods' do
    before { context.define_singleton_method(:point_count) { 3 } }

    describe '#alloc_points' do
      let(:klass) { Class.new }

      it 'accepts a klass that will be used to fill the buffer' do
        buffer = context.alloc_points klass
        buffer.each { |obj| assert_kind_of klass, obj }
      end

      it 'returns an array of the correct size' do
        buffer = context.alloc_points klass
        assert_kind_of Array, buffer
        assert_equal 3, buffer.length
      end

      it 'accepts a block' do
        buffer = context.alloc_points { 0 }
        assert_equal 0, buffer[0]
      end
    end

    describe '#each' do
      it 'returns an enumerator' do
        assert_kind_of Enumerator, context.each
      end
    end
  end

  describe '#position' do
    it 'raises an exception when not implemented' do
      assert_raises(NotImplementedError) { context.position(0) }
    end
  end

  describe 'position dependent methods' do
    before do
      context.define_singleton_method(:position) do |index|
        [index, 2 - index]
      end

      context.define_singleton_method(:point_count) { 3 }
    end

    describe '#each_position' do
      it 'iterates over each point and yields its position' do
        context.each_position do |index, x, y|
          x_ref, y_ref = context.position index

          assert_in_epsilon x_ref, x
          assert_in_epsilon y_ref, y
        end
      end

      it 'returns an enumerator when no block is given' do
        assert_kind_of Enumerator, context.each_position
      end
    end

    describe '#distance_squared' do
      it 'populates the array with squared distances' do
        target = Array.new(3)
        context.distance_squared 0, 0, target

        assert_in_epsilon 4.0, target[0]
        assert_in_epsilon 2.0, target[1]
        assert_in_epsilon 4.0, target[2]
      end
    end
  end

  describe '#index_from' do
    it 'returns the index' do
      index = rand 0..100
      assert_equal index, context.index_from(index)
    end
  end
end
