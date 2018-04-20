# frozen_string_literal: true

module Vissen
  module Output
    # The output context gives the points that relate to it their position and
    # color. Contexts can come in different forms and offer different
    # functionality but they must be able to answer three questions:
    #
    # 1. How many points are in the context,
    # 2. what is the absolute position of each point and
    # 3. what color palette corresponds to a palette index.
    #
    module Context
      # @return [Float] the normalized width of the context.
      attr_reader :width

      # @return [Float] the normalized width of the context.
      attr_reader :height

      # @return [Array<Palette>] the array of palettes used to render the
      #   context.
      attr_reader :palettes

      # Output contexts give the two things to the vixels within them: a
      # position and a color.
      #
      # The width and height are always normalized to fit within a 1 x 1 square.
      #
      # @param  width [Numeric] the width of the context.
      # @param  height [Numeric] the height of the context.
      # @param  palettes [Array<Palette>] the color palettes to use when
      #   rendering the context.
      def initialize(width, height, palettes: PALETTES)
        if width.negative? || height.negative? || (width.zero? && height.zero?)
          raise RangeError, 'Contexts needs a size in at least one dimension'
        end

        # Normalize width and height
        normalizing_factor = 1.0 / [width, height].max

        @width    = width * normalizing_factor
        @height   = height * normalizing_factor
        @palettes = palettes
      end

      # This method must be implemented by any class that includes this module.
      def point_count
        raise NotImplementedError
      end

      # @return [true, false] true if the context has only one dimension.
      def one_dimensional?
        @width == 0.0 || @height == 0.0
      end

      # Allocates, for each grid point, one object of the given class.
      # Optionally takes a block that is expected to return each new object. The
      # index of the element is passed to the given block.
      #
      # @raise  [ArgumentError] if both a class and a block are given.
      #
      # @param  klass [Class] the class of the allocated objects.
      # @param  block [Proc] the block to call for allocating each object.
      # @return [Array<klass>] an array of new objects.
      def alloc_points(klass = nil, &block)
        if klass
          raise ArgumentError if block_given?
          block = proc { klass.new }
        end

        Array.new(point_count, &block)
      end

      # Uses the width and height och the context to calculate the x and y
      # coordinates of the center point.
      #
      # @return [Array<Float>] the center coordinates.
      def center
        [width / 2.0, height / 2.0]
      end

      # Iterates over the context points. The index of the the point is passed
      # to the given block.
      #
      # @return [Enumerator, Integer] an `Enumerator` if no block is given,
      #   otherwise the number of points that was iterated over.
      def each
        point_count.times
      end

      # This method must be implemented by a class that includes this module and
      # should return the x and y coordinates of the point with the given index.
      #
      # @param  _index [Integer] the index of a point in the context.
      # @return [Array<Float>] an array containing the x and y coordinates of
      #   the point associated with the given intex.
      def position(_index)
        raise NotImplementedError
      end

      # Iterates over each point in the grid and yields the point index and x
      # and y coordinates.
      #
      # @return (see #each)
      def each_position
        return to_enum(__callee__) unless block_given?

        point_count.times do |index|
          yield(index, *position(index))
        end
      end

      # Context specific method to convert any domain specifc property (like row
      # and column) to an index. The Cloud module calls this method when
      # resolving the index given to its #[] method.
      #
      # @param  index [Object] the object or objects that are used to refer to
      #   points in this context.
      # @return [Integer] the index of the point.
      def index_from(index)
        index
      end

      # This utility method traverses the given target array and calculates for
      # each corresponding grid point index the squared distance between the
      # point and the given coordinate.
      #
      # @param  x [Numeric] the x coordinate to calculate distances from.
      # @param  y [Numeric] the y coordinate to calculate distances from.
      # @param  target [Array<Float>] the target array to populate with
      #   distances.
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
