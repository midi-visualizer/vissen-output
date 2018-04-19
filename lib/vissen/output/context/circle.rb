# frozen_string_literal: true

module Vissen
  module Output
    module Context
      # Output context with the points placed counter clockwise on a circle. By
      # specifying an offset it is possible to adjust the position of the end
      # points of the element array.
      class Circle < Cloud
        # @param  point_count [Integer] the number of points.
        # @param  offset [Float] the angle offset, in radians, of the first
        #   point.
        # @param  width [Float] (see Context)
        # @param  height [float] (see Context)
        # @param  radius [Float] the radius of the context.
        # @param  args (see CloudContext).
        def initialize(point_count,
                       offset: 0,
                       width: 1.0,
                       height: 1.0,
                       radius: [width, height].min / 2.0,
                       **args)

          circle = self.class.position_generator(point_count, radius, offset)
          center = [width.to_f / 2, height.to_f / 2]
          points = self.class.place_points point_count, center, circle

          super(points, width: width, height: height, **args)
        end

        class << self
          def position_generator(point_count, radius, offset)
            angle_factor = 2.0 * Math::PI / point_count

            proc do |index|
              angle = index * angle_factor + offset
              [radius * Math.cos(angle), radius * Math.sin(angle)]
            end
          end

          def place_points(point_count, center, generator)
            x0, y0 = center

            Array.new(point_count) do |index|
              x, y = generator.call index
              Point.new x0 + x, y0 + y
            end
          end
        end
      end
    end
  end
end
