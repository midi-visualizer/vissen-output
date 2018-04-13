# frozen_string_literal: true

module Vissen
  module Output
    module Context
      # Output context with the points placed on a circle.
      class Circle < Cloud
        # @param  radius [Float] the radius of the context.
        # @param  point_count [Integer] the number of points.
        # @param  offset [Float] the angle offset of the first point.
        # @param  width [Float] (see Context)
        # @param  height [float] (see Context)
        # @param  args (see CloudContext).
        def initialize(radius, point_count, offset: 0,
                       width: 1.0,
                       height: 1.0, **args)
          angle_factor = 2.0 * Math::PI / point_count

          x0 = width.to_f / 2
          y0 = height.to_f / 2

          points = Array.new(point_count) do |index|
            angle = index * angle_factor + offset

            x = x0 + radius * Math.cos(angle)
            y = y0 + radius * Math.sin(angle)

            Point.new x, y
          end

          super(points, width: width, height: height, **args)
        end
      end
    end
  end
end
