# frozen_string_literal: true

module Vissen
  module Output
    module Filter
      # Quantizer
      #
      # Scales and rounds the color components to only take discrete values.
      class Quantizer
        include Filter

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
