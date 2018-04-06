module Vissen
  module Output
    # Grid
    #
    # The grid structure stores the number of rows and columns as well as its
    # width and height. The dimensions are normalized to fit within a 1x1
    # square.
    #
    # Aspect ratio is defined as width/height. If it is not given each grid cell
    # is assumed to be square, meaning the aspect_ratio will equal columns/rows.
    #
    # TODO: Handle single row/column grids.
    module Grid
      attr_reader :rows, :columns, :width, :height

      def initialize(rows, columns, aspect_ratio: columns.to_f / rows)
        raise RangeError if rows <= 0 || columns <= 0
        raise ArgumentError if aspect_ratio <= 0

        @rows    = rows
        @columns = columns

        @width, @height =
          if aspect_ratio < 1.0
            [aspect_ratio, 1.0]
          else
            [1.0, 1.0 / aspect_ratio]
          end
      end

      # Points
      #
      # Returns the number of grid points.
      def points
        @rows * @columns
      end

      alias grid_points points

      # Grid Point Accessor
      #
      #
      def [](_)
        raise NotImplementedError
      end

      # Grid Likeness
      #
      # Two grids are considered equal if they share the same number of rows and
      # columns.
      def ===(other)
        other.rows == @rows && other.columns == @columns
      rescue NoMethodError
        false
      end

      # Alloc Grid Points
      #
      # Returns an array of objects of the given class.
      def alloc_points(klass = nil, &block)
        if klass
          raise ArgumentError if block_given?
          block = proc { klass.new }
        end

        Array.new(points, &block)
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

      # Position
      #
      # Returns the x and y coordinates of the grid point at the given row and
      # column.
      #
      # TODO: Fix bug when either row or column is 1
      def position(row, column)
        [
          column.to_f / (columns - 1) * width,
          row.to_f / (rows - 1) * height
        ].freeze
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

      # Each Grid Point
      #
      # Iterates over each point in the grid, yielding, depending on the arity
      # of the given block,
      # - the point index,
      # - the row and columns or
      # - the index, row and column.
      def each_point(&block)
        return to_enum(__callee__) unless block_given?

        case block.arity
        when 2
          points.times { |i| yield(*row_column_from(i)) }
        when 3
          points.times { |i| yield(i, *row_column_from(i)) }
        else points.times(&block)
        end
      end

      alias each_grid_point each_point

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