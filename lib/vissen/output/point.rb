# frozen_string_literal: true

module Vissen
  module Output
    # Points are simple two dimensional coordinates with an x and y component.
    # They are used by the `CloudContext` to keep track of the position of its
    # points.
    class Point
      # @return [Array<Float>] an array containing the x and y coordinates of
      #   the point.
      attr_reader :position

      alias to_a position

      # @param  x [Numeric] the x coordinate of the point.
      # @param  y [Numeric] the y coordinate of the point.
      # @param  scale [Numeric] a scale factor to apply to the coordinates.
      def initialize(x, y, scale: 1.0)
        @position = [x * scale, y * scale]
      end

      # @return [Float] the x coordinate of the point.
      def x
        @position[0]
      end

      # @return [Float] the y coordinate of the point.
      def y
        @position[1]
      end

      # Prevents the position from being changed.
      #
      # @return [self]
      def freeze
        @position.freeze
        super
      end

      # @return [String] a string representation of the point.
      def inspect
        format('(%0.2f,%0.2f)', *@position)
      end

      class << self
        # Coerce objects into points.
        #
        # @param  obj [#to_a] the object to be coerced into a `Point`.
        # @param  args (see #initialize)
        # @return [Point] a new `Point` object.
        def from(obj, **args)
          new(*obj.to_a, **args)
        end
      end
    end
  end
end
