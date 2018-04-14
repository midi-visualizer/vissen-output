# frozen_string_literal: true

require 'test_helper'

describe Vissen::Output::Context::Grid do
  subject { Vissen::Output::Context::Grid }

  let(:rows)         { 4 }
  let(:columns)      { 5 }
  let(:real_width)   { 10.0 }
  let(:real_height)  { 5.0 }
  let(:grid_context) { subject.new rows, columns }

  describe '#point_count' do
    it 'returns the number of points in the grid_context' do
      assert_equal (rows * columns), grid_context.point_count
    end
  end

  describe '.new' do
    it 'accepts row and column counts' do
      assert_equal rows,    grid_context.rows
      assert_equal columns, grid_context.columns
    end

    it 'defaults to a width and height proportional to the rows and columns' do
      assert_equal 1.00, grid_context.width
      assert_equal 0.75, grid_context.height
    end

    it 'accepts a width and a height' do
      grid_context = subject.new rows, columns,
                                 width: 10,
                                 height: 5

      assert_in_epsilon 1.0, grid_context.width
      assert_in_epsilon 0.5, grid_context.height
    end

    it 'works for single row contexts' do
      grid_context = subject.new(1, columns)

      assert_equal 0, grid_context.height
    end

    it 'works for single column contexts' do
      grid_context = subject.new(rows, 1)

      assert_equal 0, grid_context.width
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

  describe '#position' do
    it 'returns the position of an element index' do
      assert_equal [0.00, 0.00], grid_context.position(0)
      assert_equal [1.00, 0.00], grid_context.position((columns - 1) * rows)
      assert_equal [0.00, 0.75], grid_context.position(rows - 1)
      assert_equal [1.00, 0.75], grid_context.position(rows * columns - 1)
    end

    it 'works for 0 width contexts' do
      grid_context = subject.new(rows, 1)

      assert_equal [0.0, 0.0], grid_context.position(0)
      assert_equal [0.0, 1.0], grid_context.position(rows - 1)
    end

    it 'works for 0 height contexts' do
      grid_context = subject.new(1, columns)

      assert_equal [0.0, 0.0], grid_context.position(0)
      assert_equal [1.0, 0.0], grid_context.position(columns - 1)
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

  describe '#each_row_and_column' do
    it 'yields the index, row and column to arity 3 blocks' do
      last_index = -1

      block = proc do |index, row, column|
        assert_equal index, grid_context.index_from(row, column)
        assert_equal last_index + 1, index
        last_index += 1
      end

      grid_context.each_row_and_column(&block)
      assert_equal grid_context.point_count - 1, last_index
    end

    it 'returns an enumerator when no block is given' do
      assert_kind_of Enumerator, grid_context.each_row_and_column
    end
  end
end
