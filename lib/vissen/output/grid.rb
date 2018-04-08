require 'forwardable'

module Vissen
  module Output
    # Grid
    #
    #
    module Grid
      extend Forwardable
      attr_reader :context, :elements

      def_delegators :@context, :rows, :columns, :width, :height
      def_delegators :@elements, :each, :each_with_index

      # Initialize
      #
      # The grid is setup with a grid context as well as a class to places
      # instances of in every grid point.
      def initialize(grid_context, elements_klass = nil, &block)
        @context  = grid_context
        @elements =
          if block_given?
            raise ArgumentError if elements_klass
            grid_context.alloc_points(&block).freeze
          else
            grid_context.alloc_points(elements_klass).freeze
          end
      end

      def each_with_row_and_column
        return to_enum(__callee__) unless block_given?
        @context.each { |i, r, c| yield @elements[i], r, c }
      end

      def each_with_position
        return to_enum(__callee__) unless block_given?
        @context.each_position { |i, x, y| yield @elements[i], x, y }
      end

      # Point Accessor
      #
      # Returns the point at the given row and column.
      def [](row, column)
        @elements[@context.index_from row, column]
      end

      # Grid Likeness
      #
      # Two grids are considered equal if they share the same context.
      def ===(other)
        @context == other.context
      rescue NoMethodError
        false
      end
    end
  end
end
