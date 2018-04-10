# frozen_string_literal: true

module Vissen
  module Output
    # Context
    #
    #
    module Context
      attr_reader :width, :height

      def initialize(width, height)
        if width.negative? || height.negative? || (width.zero? && height.zero?)
          raise RangeError, 'Contexts needs a size in at least one dimension'
        end

        # Normalize width and height
        normalizing_factor = 1.0 / [width, height].max

        @width  = width * normalizing_factor
        @height = height * normalizing_factor
      end

      # Point Count
      #
      # Returns the number of grid points.
      def point_count
        raise NotImplementedError
      end

      # One Dimensional?
      #
      # Returns true if the context only has one dimention.
      def one_dimensional?
        @width == 0.0 || @height == 0.0
      end

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

        Array.new(point_count, &block)
      end

      # Position
      #
      # Should return the x and y coordinates of the point with the given index.
      def position(_index)
        raise NotImplementedError
      end

      def each
        point_count.times
      end

      # Each Position
      #
      # Iterates over each point in the grid and yields the point index and x
      # and y coordinates.
      def each_position
        return to_enum(__callee__) unless block_given?

        point_count.times do |index|
          yield(index, *position(index))
        end
      end

      # Distance Squared
      #
      # This utility method traverses the given target array and calculates for
      # each corresponding grid point index the squared distance between the
      # point and the given coordinate.
      def distance_squared(x, y, target)
        target.each_with_index do |_, i|
          x_i, y_i = position i
          dx = x_i - x
          dy = y_i - y
          target[i] = (dx * dx) + (dy * dy)
        end
      end
    end
  end
end
