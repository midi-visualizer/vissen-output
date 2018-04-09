module Vissen
  module Output
    # Grid Context
    #
    # The grid structure stores the number of rows and columns as well as its
    # width and height. The dimensions are normalized to fit within a 1x1
    # square.
    #
    # Aspect ratio is defined as width/height. If it is not given each grid cell
    # is assumed to be square, meaning the aspect_ratio will equal columns/rows.
    #
    # TODO: Handle single row/column grids.
    module GridContext
      attr_reader :rows, :columns, :width, :height

      def initialize(rows, columns, aspect_ratio: columns.to_f / rows)
        raise RangeError if rows <= 0 || columns <= 0
        raise ArgumentError if aspect_ratio <= 0

        @rows    = rows
        @columns = columns

        @width, @height =
          if rows == 1
            [1.0, 0.0]
          elsif columns == 1
            [0.0, 1.0]
          elsif aspect_ratio < 1.0
            [aspect_ratio, 1.0]
          else
            [1.0, 1.0 / aspect_ratio]
          end

        # Define #position dynamically based on the
        # calculated width and height
        x_factor = columns == 1 ? 0.0 : width / (columns - 1)
        y_factor = rows == 1 ? 0.0 : height / (rows - 1)

        # Position
        #
        # Returns the x and y coordinates of the grid point at the given row and
        # column.
        define_singleton_method :position do |row, column|
          [
            x_factor * column,
            y_factor * row
          ].freeze
        end
      end

      # Point Count
      #
      # Returns the number of grid points.
      def point_count
        @rows * @columns
      end

      alias grid_points point_count
      alias points point_count

      # Alloc Grid Points
      #
      # Returns an array of objects of the given class. Optionally takes a block
      # that is expected to return each new object. The row and column of each
      # element are passed to the given block.
      def alloc_points(klass = nil, &block)
        if klass
          raise ArgumentError if block_given?
          block = proc { klass.new }
        end

        Array.new(points) { |i| block.call(*row_column_from(i)) }
      end

      # Index From
      #
      # Returns the index of a row and column.
      #
      # Warning: no range check is performed.
      def index_from(row, column)
        column * @rows + row
      end

      # Row-Column From
      #
      # Returns the row and column of a given index.
      def row_column_from(index)
        row    = (index % @rows)
        column = (index / @rows)
        [row, column]
      end

      # Distance Squared
      #
      # This utility method traverses the given target array and calculates for
      # each corresponding grid point index the squared distance between the
      # point and the given coordinate.
      def distance_squared(x, y, target)
        target.each_with_index do |_, i|
          row, column = row_column_from i
          x_i, y_i = position row, column
          dx = x_i - x
          dy = y_i - y
          target[i] = (dx * dx) + (dy * dy)
        end
      end

      # Each
      #
      # Iterates over each point in the grid and yields the index, row and
      # column.
      def each
        return to_enum(__callee__) unless block_given?

        points.times { |i| yield(i, *row_column_from(i)) }
      end

      # Each Position
      #
      # Iterates over each point in the grid and yields the point index and x
      # and y coordinates.
      def each_position
        return to_enum(__callee__) unless block_given?

        x_coef = width / (columns - 1)
        y_coef = height / (rows - 1)

        points.times do |index|
          row, column = row_column_from index

          x = column * x_coef
          y = row * y_coef

          yield index, x, y
        end
      end
    end
  end
end
