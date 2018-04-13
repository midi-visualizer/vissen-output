# frozen_string_literal: true

module Vissen
  module Output
    module Context
      # Output context with the points placed on a circle.
      class Circle < Cloud
        # @param  radius [Float] the radius of the context.
        # @param  point_count [Integer] the number of points.
        # @param  offset [Float] the angle offset of the first point.
        # @param  args (see CloudContext).
        def initialize(radius, point_count, offset: 0, **args)
          angle_factor = 2.0 * Math::PI / point_count
          points = Array.new(point_count) do |index|
            angle = index * angle_factor + offset

            x = radius * Math.cos(angle)
            y = radius * Math.sin(angle)

            Point.new x, y
          end

          super(points, **args)
        end
      end
    end
  end
end
