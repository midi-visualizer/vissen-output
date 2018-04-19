# frozen_string_literal: true

require 'test_helper'

class BufferTestTarget
  include Vissen::Output::Buffer
end

describe Vissen::Output::Buffer do
  subject { BufferTestTarget }

  let(:context_klass) { Vissen::Output::Context::Grid }
  let(:context)       { context_klass.new 2, 3 }
  let(:element_klass) { Class.new }
  let(:buffer)        { subject.new context, element_klass }

  describe '.new' do
    it 'allocates an array of elements of the given class' do
      elements = buffer.elements
      assert_equal 6, elements.length
      assert(elements.all? { |e| e.class == element_klass })
    end

    it 'accepts a block for allocating elements' do
      buffer = subject.new(context) { |i| i }
      elements = buffer.elements
      assert_equal 6, elements.length
      assert(elements.each_with_index.all? { |e, i| e == i })
    end

    it 'raises an ArgumentError if both a block and element_klass are given' do
      assert_raises(ArgumentError) { subject.new(context, element_klass) {} }
    end
  end

  describe '#each_with_position' do
    it 'iterates over the elements and their position' do
      element_count = 0
      elements = buffer.elements
      buffer.each_with_position do |element, x, y|
        assert_equal elements[element_count], element
        assert_equal context.position(element_count)[0], x
        assert_equal context.position(element_count)[1], y

        element_count += 1
      end

      assert_equal 6, element_count
    end
  end

  describe '#share_context?' do
    it 'returns true when the other object share the same context' do
      other = subject.new context, element_klass
      assert_operator buffer, :share_context?, other
    end

    it 'returns false when the other object has a different context' do
      other_context = context_klass.new 2, 3
      other = subject.new other_context, element_klass
      refute_operator buffer, :share_context?, other
    end

    it 'returns false for other objects' do
      refute_operator buffer, :share_context?, Object.new
    end
  end
end
