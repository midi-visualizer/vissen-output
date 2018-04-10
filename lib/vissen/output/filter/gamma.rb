# frozen_string_literal: true

module Vissen
  module Output
    module Filter
      # Gamma
      #
      # Applies gamma correction to the given PixelGrid.
      class Gamma
        include Filter

        attr_reader :value

        def initialize(*args, value: 2.2)
          super(*args)

          @value = value

          freeze
        end

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
