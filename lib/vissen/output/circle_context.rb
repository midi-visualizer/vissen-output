# frozen_string_literal: true

module Vissen
  module Output
    # Output context with the points placed on a circle.
    class CircleContext < CloudContext
      # @param  radius [Float] the radius of the context.
      # @param  point_count [Integer] the number of points.
      # @param  args (see CloudContext).
      def initialize(radius, point_count, **args)
        angle_factor = 2.0 * Math::PI / point_count
        points = Array.new(point_count) do |index|
          angle = index * angle_factor
          
          x = radius * Math.cos(angle)
          y = radius * Math.sin(angle)
          
          Point.new x, y
        end
        
        super(points, **args)
      end
    end
  end
end
