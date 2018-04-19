# frozen_string_literal: true

module Vissen
  module Output
    module Context
      # The cloud context imposes no structure on the placement of its elements
      # but instead accepts coordinates for each individual point.
      #
      # == Usage
      # The following example creates a context with three points, placed on a
      # straight line.
      #
      #   placement = [[0.1, 0.1],
      #                [0.5, 0.5],
      #                [0.9, 0.9]]
      #   context = Cloud.new placement
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

        # Prevents any more points from being added.
        #
        # @return [self]
        def freeze
          @points.freeze
          super
        end

        # See `Context#point_count`.
        #
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
            d2 =
              if distance
                (distance**2).tap do |d|
                  raise RangeError if 2 * d * point_count > width * height
                end
              else
                (width * height) / (2.0 * point_count)
              end

            points = place_points point_count,
                                  position_scrambler(width, height),
                                  distance_condition(d2)

            new(points, width: width, height: height, **args)
          end

          private

          # @param  x_max [#to_f] the largest value x is allowed to take.
          # @param  y_max [#to_f] the largest value y is allowed to take.
          # @return [Proc] a proc that ranomizes the first and second element of
          #   the given array.
          def position_scrambler(x_max, y_max)
            x_range = 0.0..x_max.to_f
            y_range = 0.0..y_max.to_f

            proc do |pos|
              pos[0] = rand x_range
              pos[1] = rand y_range
              pos
            end
          end

          def place_points(point_count, scrambler, condition)
            points = Array.new(point_count) { [0.0, 0.0] }
            points.each_with_index do |point, i|
              loop do
                scrambler.call point
                break if points[0...i].all?(&condition.curry[point])
              end
            end
            points
          end

          def distance_condition(distance_squared)
            ->(p, q) { (p[0] - q[0])**2 + (p[1] - q[1])**2 > distance_squared }
          end
        end
      end
    end
  end
end
