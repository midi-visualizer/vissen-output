module Vissen
  module Output
    module Filter
      class Gamma
        include Filter

        attr_reader :value

        def initialize(*args, value: 2.2)
          super(*args)

          @value = value

          freeze
        end

        def apply(pixel_grid)
          pixel_grid.each do |pixel|
            pixel.r = pixel.r**@value
            pixel.g = pixel.g**@value
            pixel.b = pixel.b**@value
          end
        end
      end
    end
  end
end
