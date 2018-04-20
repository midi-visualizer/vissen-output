# frozen_string_literal: true

module Vissen
  module Output
    module Context
      # Output context with the points placed counter clockwise on a circle. By
      # specifying an offset it is possible to adjust the position of the end
      # points of the element array.
      class Circle < Cloud
        # @param  point_count [Integer] the number of points.
        # @param  offset [Numeric] the angle offset, in radians, of the first
        #   point.
        # @param  width [Numeric] (see Context)
        # @param  height [Numeric] (see Context)
        # @param  radius [Numeric] the radius of the context.
        # @param  args (see CloudContext).
        def initialize(point_count,
                       offset: 0,
                       width: 1.0,
                       height: 1.0,
                       radius: [width, height].min / 2.0,
                       **args)

          circle = self.class.position_generator(point_count, radius, offset)
          center = [width.to_f / 2, height.to_f / 2]
          points = self.class.place_points circle, center

          super(points, width: width, height: height, **args)
        end

        class << self
          # Creates a generator (`Enumerator`) for x and y coordinates
          # equidistantly placed along a circle centered around (0, 0).
          #
          # @param  point_count [Integer] the number of points along the circle.
          # @param  radius [Numeric] the radius of the circle.
          # @param  offset [Numeric] the angular offset of the first point. An
          #   offset of pi/2 would place the first point at the twelve o'clock
          #   position.
          # @return [Enumerator] an enumerator that yields `point_count` x and y
          #   coordinates along a circle.
          def position_generator(point_count, radius, offset = 0)
            angle_factor = 2.0 * Math::PI / point_count

            Enumerator.new(point_count) do |y|
              point_count.times do |index|
                angle = index * angle_factor + offset
                y << [radius * Math.cos(angle), radius * Math.sin(angle)]
              end
            end
          end

          # Uses a position generator to allocate an array of `Point` objects
          # placed arount a circle centered around the given coordinates.
          #
          # @param  generator [Enumerator] the position generator
          #   (see .position_generator).
          # @param  center [Array<Numeric>] the x and y coordinates of the
          #   circle center.
          # @return [Array<Point>] an array of `Point` objects placed around a
          #   circle.
          def place_points(generator, center)
            x0, y0 = center
            generator.map { |x, y| Point.new x0 + x, y0 + y }
          end
        end
      end
    end
  end
end
