# frozen_string_literal: true

require 'forwardable'

module Vissen
  module Output
    # Grid
    #
    #
    module Grid
      extend  Forwardable
      include Buffer

      def_delegators :@context, :rows, :columns

      def each_with_row_and_column
        return to_enum(__callee__) unless block_given?
        @context.each_row_and_column { |i, r, c| yield @elements[i], r, c }
      end

      # Point Accessor
      #
      # Returns the point at the given row and column.
      def [](row, column)
        @elements[@context.index_from row, column]
      end
    end
  end
end
