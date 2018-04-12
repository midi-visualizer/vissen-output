# frozen_string_literal: true

module Vissen
  module Output
    module Filter
      # Applies gamma correction to the given PixelGrid.
      class Gamma
        include Filter

        # @return [Float] the gamma correction value.
        attr_reader :value

        # @param  args (see Filter)
        # @param  value [Float] the gamma correction value.
        def initialize(*args, value: 2.2)
          super(*args)

          @value = value

          freeze
        end

        # Applies the filter to the given pixel cloud.
        #
        # @see Filter
        # @param pixel_cloud [PixelCloud] the pixel cloud to perform the filter
        #   operation on.
        def apply(pixel_cloud)
          pixel_cloud.each do |pixel|
            pixel.r = pixel.r**@value
            pixel.g = pixel.g**@value
            pixel.b = pixel.b**@value
          end
        end
      end
    end
  end
end
