# frozen_string_literal: true

module Vissen
  module Output
    # Cloud Context
    #
    #
    class CloudContext
      include Context

      attr_reader :points

      def initialize(points, width: 1.0, height: 1.0, **args)
        super(width, height, **args)

        factor = @width / width

        @points = points.map { |point| Point.from point, scale: factor }
      end

      # Point Count
      #
      # Returns the number of grid points.
      def point_count
        @points.length
      end

      # Position
      #
      # Returns the x and y coordinates of a point.
      def position(index)
        @points[index].position
      end
    end
  end
end
