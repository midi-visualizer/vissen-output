# frozen_string_literal: true

module Vissen
  module Output
    # The grid structure stores the number of rows and columns as well as its
    # width and height. The dimensions are normalized to fit within a 1x1
    # square.
    #
    # Aspect ratio is defined as width/height. If it is not given each grid cell
    # is assumed to be square, meaning the aspect_ratio will equal columns/rows.
    class GridContext
      include Context

      attr_reader :rows, :columns

      # TODO: Replace aspect_ratio with width and height to conform better with
      #       other context types.
      #
      # @param  rows [Integer] the number of rows in the grid.
      # @param  columns [Integer] the number of columns in the grid.
      # @param  aspect_ratio [Float] the grid aspect ratio defined as width
      #   divided by height.
      # @param  args (see Context)
      def initialize(rows, columns, aspect_ratio: columns.to_f / rows, **args)
        raise RangeError if rows <= 0 || columns <= 0
        raise ArgumentError if aspect_ratio <= 0

        @rows    = rows
        @columns = columns

        width, height =
          if rows == 1
            [1.0, 0.0]
          elsif columns == 1
            [0.0, 1.0]
          elsif aspect_ratio < 1.0
            [aspect_ratio, 1.0]
          else
            [1.0, 1.0 / aspect_ratio]
          end

        super(width, height, **args)

        # Define #position dynamically based on the
        # calculated width and height
        x_factor = columns == 1 ? 0.0 : width / (columns - 1)
        y_factor = rows == 1 ? 0.0 : height / (rows - 1)

        # Position
        #
        # Returns the x and y coordinates of the grid point at the given index.
        define_singleton_method(:position) do |index|
          [
            x_factor * (index / rows),
            y_factor * (index % rows)
          ].freeze
        end
      end

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
    end
  end
end
