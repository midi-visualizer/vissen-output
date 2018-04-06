require 'test_helper'

class TestTarget
  include Vissen::Output::Grid
end

describe Vissen::Output::Grid do
  subject { TestTarget }

  let(:rows)        { 6 }
  let(:columns)     { 8 }
  let(:real_width)  { 10.0 }
  let(:real_height) { 5.0 }
  let(:grid)        { subject.new rows, columns }

  describe '#points' do
    it 'returns the number of points in the grid' do
      assert_equal (rows * columns), grid.points
    end
  end

  describe '.new' do
    it 'accepts row and column counts' do
      assert_equal rows,    grid.rows
      assert_equal columns, grid.columns
      # The points are assumed to be placed in a square grid
      assert_equal 1.00, grid.width
      assert_equal 0.75, grid.height
    end

    it 'accepts an aspect ratio defined as w/h greater than 1' do
      grid =
        subject.new(rows, columns, aspect_ratio: real_width / real_height)

      assert_equal 1.0, grid.width
      assert_equal 0.5, grid.height
    end

    it 'accepts an aspect ratio defined as w/h less than 1' do
      grid =
        subject.new(rows, columns, aspect_ratio: real_height / real_width)

      assert_equal 0.5, grid.width
      assert_equal 1.0, grid.height
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

  describe '#[]' do
    it 'raises an error if it is not implemented' do
      assert_raises(NotImplementedError) { grid[0] }
    end
  end

  describe '#===' do
    it 'returns true when two grids have the same number of rows and columns' do
      other = subject.new rows, columns
      assert_operator grid, :===, other
    end

    it 'returns true even though the aspect_ratio differs' do
      other = subject.new rows, columns, aspect_ratio: 1.0
      assert_operator grid, :===, other
    end

    it 'returns false when the number of rows and columns differ' do
      other_a = subject.new rows - 1, columns
      other_b = subject.new rows, columns + 1

      refute_operator grid, :===, other_a
      refute_operator grid, :===, other_b
    end

    it 'returns false when the other object does not have rows and columns' do
      other = Object.new
      refute_operator grid, :===, other
    end
  end

  describe '#alloc_points' do
    let(:klass) { Class.new }

    it 'accepts a klass that will be used to fill the buffer' do
      buffer = grid.alloc_points klass
      buffer.each { |obj| assert_kind_of klass, obj }
    end

    it 'returns an array of the correct size' do
      buffer = grid.alloc_points klass
      assert_kind_of Array, buffer
      assert_equal (rows * columns), buffer.length
    end

    it 'accepts a block' do
      buffer = grid.alloc_points { 0 }
      assert_equal 0, buffer[0]
    end
  end

  describe '#position' do
    it 'returns the position of a row and column' do
      assert_equal [0.00, 0.00], grid.position(0, 0)
      assert_equal [1.00, 0.00], grid.position(0, columns - 1)
      assert_equal [0.00, 0.75], grid.position(rows - 1, 0)
      assert_equal [1.00, 0.75], grid.position(rows - 1, columns - 1)
    end
  end

  describe '#distance_squared' do
    it 'populates the array with squared distances' do
      target = Array.new(rows * columns)
      grid.distance_squared 0, 0, target
      x = grid.width
      y = grid.height

      assert_in_epsilon 0, target[0]
      assert_in_epsilon y**2, target[grid.index_from(rows - 1, 0)]
      assert_in_epsilon x**2, target[grid.index_from(0, columns - 1)]
      assert_in_epsilon x**2 + y**2, target[-1]
    end
  end

  describe '#index_from' do
    it 'converts a row and a column to an index' do
      row   = rand rows
      col   = rand columns
      index = grid.index_from row, col

      assert_equal (col * rows + row), index
    end

    it 'is consistent with #row_column_from' do
      (rows * columns).times do |index|
        row, col = grid.row_column_from index
        index_calc = grid.index_from row, col
        assert_equal index, index_calc
      end
    end
  end

  describe '#each_point' do
    it 'yields the index to arity 1 blocks' do
      last_index = -1

      block = proc do |index|
        assert_equal last_index + 1, index
        last_index += 1
      end

      grid.each_point(&block)
      assert_equal grid.points - 1, last_index
    end

    it 'yields the row and column to arity 2 blocks' do
      last_index = -1

      block = proc do |row, column|
        index = grid.index_from row, column
        assert_equal last_index + 1, index
        last_index += 1
      end

      grid.each_point(&block)
      assert_equal grid.points - 1, last_index
    end

    it 'yields the index, row and column to arity 3 blocks' do
      last_index = -1

      block = proc do |index, row, column|
        assert_equal index, grid.index_from(row, column)
        assert_equal last_index + 1, index
        last_index += 1
      end

      grid.each_point(&block)
      assert_equal grid.points - 1, last_index
    end
  end
end
