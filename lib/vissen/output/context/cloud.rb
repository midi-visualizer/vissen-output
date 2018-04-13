# frozen_string_literal: true

module Vissen
  module Output
    module Context
      # Cloud Context
      #
      #
      class Cloud
        include Context

        # @return [Array<Point>] the points in the context.
        attr_reader :points

        # @param  points [Array<Point>, Array<Array<Integer>>] the position of
        #   the points in the context.
        # @param  width [Float] the width of the context.
        # @param  height [Float] the height of the context.
        # @param  args (see Context).
        def initialize(points, width: 1.0, height: 1.0, **args)
          super(width, height, **args)

          factor = @width / width

          @points = points.map { |point| Point.from point, scale: factor }
          freeze
        end

        def freeze
          @points.freeze
          super
        end

        # @return [Integer] the number of grid points.
        def point_count
          @points.length
        end

        # @return [Array<Integer>] the x and y coordinates of a point.
        def position(index)
          @points[index].position
        end

        class << self
          # Randomly places points separated by a minimum distance. Note that
          # the algorithm is nondeterministic in the time it takes to find the
          # points.
          #
          # Draws a random point from the space of valid coordinates and
          # calculates the distance to all previously selected points. If the
          # distances are all greater than the given value the point is accepted
          # and the process repeats until all points have been found.
          #
          # @raise  [RangeError] if distance is too great and the allocation
          #   algorithm therefore is unlikely to converge.
          #
          # @param  point_count [Integer] the number of points to scatter.
          # @param  width [Float] the width of the context.
          # @param  height [Float] the height of the context.
          # @param  distance [Float] the minimum distance between each point.
          # @param  args (see Context).
          def scatter(point_count,
                      width: 1.0,
                      height: 1.0,
                      distance: nil,
                      **args)
            points = Array.new(point_count) { [0.0, 0.0] }

            x_range = 0.0..width.to_f
            y_range = 0.0..height.to_f

            if distance
              d2 = distance**2
              raise RangeError if 2 * d2 * point_count > width * height
            else
              d2 = (width * height) / (2.0 * point_count)
            end

            condition = ->(p, q) { (p[0] - q[0])**2 + (p[1] - q[1])**2 > d2 }

            points.each_with_index do |point, i|
              loop do
                point[0] = rand x_range
                point[1] = rand y_range

                break if points[0...i].all?(&condition.curry[point])
              end
            end

            new(points, width: width, height: height, **args)
          end
        end
      end
    end
  end
end
