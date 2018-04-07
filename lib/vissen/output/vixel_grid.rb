require 'forwardable'

module Vissen
  module Output
    # Vixel Grid
    #
    #
    class VixelGrid
      include Grid

      attr_accessor :intensity
      alias vixels elements

      def initialize(context, intensity: 1.0)
        super(context, Vixel)
        @intensity = intensity
      end

      # Render
      #
      # Render the layer vixels to the given buffer.
      def render(buffer, intensity: 1.0)
        buffer.each_with_index do |color, index|
          vixel = vixels[index]
          next unless vixel.i > 0

          ratio = vixel.i * intensity * @intensity
          self.class.mix_color color, context.palettes[vixel.p][vixel.q], ratio
        end
      end

      def vixel_count
        vixels.length
      end

      class << self
        # Mix Color
        #
        # Mixes a with b using the given ratio and updates a with the new color.
        # When ratio = 0.0 a will be untouched and when ratio = 1.0 then a == b.
        def mix_color(a, b, ratio)
          a.r = b.r * ratio + a.r * (1 - ratio)
          a.g = b.g * ratio + a.g * (1 - ratio)
          a.b = b.b * ratio + a.b * (1 - ratio)
        end
      end
    end
  end
end
