# frozen_string_literal: true

module Vissen
  module Output
    module Filter
      # Scales and rounds the color components to only take discrete values.
      class Quantizer
        include Filter

        # @raise  [RangeError] if steps < 2.
        # @raise  [ArgumentError] if the range is exclusive and has a floating
        #   point end value.
        #
        # @param  args (see Filter)
        # @param  steps [Integer] the number of quantized steps.
        # @param  range [Range] the range in which the quantized values should
        #   lie.
        def initialize(*args, steps: 256, range: 0...steps)
          super(*args)

          raise RangeError if steps < 2

          from = range.begin
          to   = if range.exclude_end?
                   raise ArgumentError if range.end.is_a?(Float)
                   range.end - 1
                 else
                   range.end
                 end

          design_function from, to, steps

          freeze
        end

        # Applies the filter to the given pixel cloud.
        #
        # @see Filter
        # @param pixel_cloud [PixelCloud] the pixel cloud to perform the filter
        #   operation on.
        def apply(pixel_cloud)
          pixel_cloud.each do |pixel|
            pixel.r = @fn.call pixel.r
            pixel.g = @fn.call pixel.g
            pixel.b = @fn.call pixel.b
          end
        end

        private

        def design_function(from, to, steps)
          steps -= 1
          @fn =
            if from.zero? && to == steps
              ->(v) { (v * to).round }
            else
              factor = (to - from).to_f / steps
              ->(v) { from + (v * steps).round * factor }
            end
        end
      end
    end
  end
end
