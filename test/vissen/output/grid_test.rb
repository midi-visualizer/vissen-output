# frozen_string_literal: true

class TestGridTarget
  include Vissen::Output::Grid
end

describe Vissen::Output::Grid do
  subject { TestGridTarget }

  let(:rows)        { 6 }
  let(:columns)     { 8 }
  let(:context)     { Vissen::Output::GridContext.new rows, columns }
  let(:point_klass) { Struct.new :index }
  let(:grid)        { subject.new context, point_klass }

  describe '.new' do
    it 'allocates elements using the given element class' do
      assert_kind_of point_klass, grid.elements[0]
    end

    it 'accepts a block used for allocating the elements' do
      index = 0
      grid = subject.new(context) do |i|
        assert_equal index, i
        index += 1
        point_klass.new i
      end

      assert_equal (rows * columns), index
      some_index = rand index
      assert_equal some_index, grid.elements[some_index].index
    end
  end

  describe '#each_with_row_and_column' do
    it 'returns an enumerator when no block is given' do
      assert_kind_of Enumerator, grid.each_with_row_and_column
    end

    it 'yields the element, row and column to the block' do
      index = 0
      grid.each_with_row_and_column do |element, row, column|
        true_row, true_column = context.row_column_from index

        assert_equal grid.elements[index], element
        assert_equal true_row, row
        assert_equal true_column, column

        index += 1
      end
      assert_equal (rows * columns), index
    end
  end

  describe '#each_with_position' do
    it 'returns an enumerator when no block is given' do
      assert_kind_of Enumerator, grid.each_with_position
    end

    it 'yields the element and x and y coordinates to the block' do
      index = 0
      grid.each_with_position do |element, x, y|
        true_x, true_y = context.position index

        assert_equal grid.elements[index], element
        assert_in_epsilon true_x, x
        assert_in_epsilon true_y, y

        index += 1
      end
      assert_equal (rows * columns), index
    end
  end

  describe '#[]' do
    it 'returns the element at the given row and column' do
      row    = rand rows
      column = rand columns
      index  = context.index_from row, column

      assert_equal grid.elements[index], grid[row, column]
    end
  end

  describe '#===' do
    it 'returns true for grids that share the same context' do
      other_grid = subject.new context, point_klass

      assert_operator grid, :===, grid
      assert_operator grid, :===, other_grid
    end

    it 'returns false for grids with different contexts' do
      other_context = Vissen::Output::GridContext.new rows, columns
      other_grid = subject.new other_context, point_klass

      refute_operator grid, :===, other_grid
    end

    it 'returns false for other objects' do
      refute_operator grid, :===, Object.new
    end
  end
end
