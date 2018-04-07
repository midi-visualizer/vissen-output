require 'test_helper'

class TestGridContextTarget
  include Vissen::Output::GridContext
end

describe Vissen::Output::GridContext do
  subject { TestGridContextTarget }

  let(:rows)        { 6 }
  let(:columns)     { 8 }
  let(:real_width)  { 10.0 }
  let(:real_height) { 5.0 }
  let(:grid_context) { subject.new rows, columns }

  describe '#points' do
    it 'returns the number of points in the grid_context' do
      assert_equal (rows * columns), grid_context.points
    end
  end

  describe '.new' do
    it 'accepts row and column counts' do
      assert_equal rows,    grid_context.rows
      assert_equal columns, grid_context.columns
      # The points are assumed to be placed in a square grid_context
      assert_equal 1.00, grid_context.width
      assert_equal 0.75, grid_context.height
    end

    it 'accepts an aspect ratio defined as w/h greater than 1' do
      grid_context =
        subject.new(rows, columns, aspect_ratio: real_width / real_height)

      assert_equal 1.0, grid_context.width
      assert_equal 0.5, grid_context.height
    end

    it 'accepts an aspect ratio defined as w/h less than 1' do
      grid_context =
        subject.new(rows, columns, aspect_ratio: real_height / real_width)

      assert_equal 0.5, grid_context.width
      assert_equal 1.0, grid_context.height
    end

    it 'raises a RangeError when rows <= 0' do
      assert_raises(RangeError) do
        subject.new 0, columns
      end
    end

    it 'raises a RangeError when columns <= 0' do
      assert_raises(RangeError) do
        subject.new rows, 0
      end
    end
  end

  describe '#alloc_points' do
    let(:klass) { Class.new }

    it 'accepts a klass that will be used to fill the buffer' do
      buffer = grid_context.alloc_points klass
      buffer.each { |obj| assert_kind_of klass, obj }
    end

    it 'returns an array of the correct size' do
      buffer = grid_context.alloc_points klass
      assert_kind_of Array, buffer
      assert_equal (rows * columns), buffer.length
    end

    it 'accepts a block' do
      buffer = grid_context.alloc_points { 0 }
      assert_equal 0, buffer[0]
    end
  end

  describe '#position' do
    it 'returns the position of a row and column' do
      assert_equal [0.00, 0.00], grid_context.position(0, 0)
      assert_equal [1.00, 0.00], grid_context.position(0, columns - 1)
      assert_equal [0.00, 0.75], grid_context.position(rows - 1, 0)
      assert_equal [1.00, 0.75], grid_context.position(rows - 1, columns - 1)
    end
  end

  describe '#distance_squared' do
    it 'populates the array with squared distances' do
      target = Array.new(rows * columns)
      grid_context.distance_squared 0, 0, target
      x = grid_context.width
      y = grid_context.height

      assert_in_epsilon 0, target[0]
      assert_in_epsilon y**2, target[grid_context.index_from(rows - 1, 0)]
      assert_in_epsilon x**2, target[grid_context.index_from(0, columns - 1)]
      assert_in_epsilon x**2 + y**2, target[-1]
    end
  end

  describe '#index_from' do
    it 'converts a row and a column to an index' do
      row   = rand rows
      col   = rand columns
      index = grid_context.index_from row, col

      assert_equal (col * rows + row), index
    end

    it 'is consistent with #row_column_from' do
      (rows * columns).times do |index|
        row, col = grid_context.row_column_from index
        index_calc = grid_context.index_from row, col
        assert_equal index, index_calc
      end
    end
  end

  describe '#each' do
    it 'yields the index, row and column to arity 3 blocks' do
      last_index = -1

      block = proc do |index, row, column|
        assert_equal index, grid_context.index_from(row, column)
        assert_equal last_index + 1, index
        last_index += 1
      end

      grid_context.each(&block)
      assert_equal grid_context.points - 1, last_index
    end

    it 'returns an enumerator when no block is given' do
      assert_kind_of Enumerator, grid_context.each
    end
  end

  describe '#each_position' do
    it 'iterates over each point and yields its position' do
      grid_context.each_position do |index, x, y|
        row, column = grid_context.row_column_from index
        x_ref, y_ref = grid_context.position row, column

        assert_in_epsilon x_ref, x
        assert_in_epsilon y_ref, y
      end
    end

    it 'returns an enumerator when no block is given' do
      assert_kind_of Enumerator, grid_context.each_position
    end
  end
end
