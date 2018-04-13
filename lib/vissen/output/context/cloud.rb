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
      end
    end
  end
end
