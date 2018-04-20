# frozen_string_literal: true

module Vissen
  module Output
    module Context
      # The grid structure stores the number of rows and columns as well as its
      # width and height. The dimensions are normalized to fit within a 1x1
      # square.
      #
      # Aspect ratio is defined as width/height. If it is not given each grid
      # cell is assumed to be square, meaning the aspect_ratio will equal
      # columns/rows.
      class Grid
        include Context

        # @return [Integer] the number of rows in the grid.
        attr_reader :rows

        # @return [Integer] the number of columns in the grid.
        attr_reader :columns

        # @param  rows [Integer] the number of rows in the grid.
        # @param  columns [Integer] the number of columns in the grid.
        # @param  width [Numeric] (see Context)
        # @param  height [Numeric] (see Context)
        # @param  args (see Context)
        def initialize(rows,
                       columns,
                       width: (columns - 1).to_f,
                       height: (rows - 1).to_f,
                       **args)
          raise RangeError if rows <= 0 || columns <= 0

          @rows    = rows
          @columns = columns

          super(width, height, **args)

          define_position
        end

        # See `Context#point_count`.
        #
        # @return [Integer] the number of grid points.
        def point_count
          @rows * @columns
        end

        # See `Context#index_from`.
        #
        # WARNING: no range check is performed.
        #
        # @param  row [Integer] the row of the point of interest.
        # @param  column [Integer] the column of the point of interest.
        # @return [Integer] the index of a row and column.
        def index_from(row, column)
          column * @rows + row
        end

        # Calculates the row and column of the the point stored at the given
        # index.
        #
        # @param  index [Integer] the index of the point of interest.
        # @return [Array<Integer>] the row and column of a given index.
        def row_column_from(index)
          row    = (index % @rows)
          column = (index / @rows)
          [row, column]
        end

        # Iterates over each point in the grid and yields the index, row and
        # column.
        #
        # @return [Integer] the number of points in the grid.
        def each_row_and_column
          return to_enum(__callee__) unless block_given?

          point_count.times { |i| yield(i, *row_column_from(i)) }
        end

        private

        def define_position
          # Define #position dynamically based on the
          # calculated width and height
          x_factor = @columns == 1 ? 0.0 : width / (@columns - 1)
          y_factor = @rows == 1 ? 0.0 : height / (@rows - 1)

          # Position
          #
          # Returns the x and y coordinates of the grid point at the given
          # index.
          define_singleton_method(:position) do |index|
            [
              x_factor * (index / @rows),
              y_factor * (index % @rows)
            ].freeze
          end
        end
      end
    end
  end
end
