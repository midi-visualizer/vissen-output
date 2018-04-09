# frozen_string_literal: true

module Vissen
  module Output
    # Vixel Grid
    #
    #
    class VixelGrid
      include Grid

      attr_accessor :intensity, :palette
      alias vixels elements

      def initialize(context, palette: 0, intensity: 1.0)
        super(context, Vixel)

        @palette   = palette
        @intensity = intensity
      end

      # Render
      #
      # Render the layer vixels to the given buffer.
      def render(buffer, intensity: 1.0)
        palette = context.palettes[@palette]
        buffer.each_with_index do |color, index|
          vixel = vixels[index]
          next unless vixel.i.positive?

          ratio = vixel.i * intensity * @intensity
          color.mix_with! palette[vixel.p], ratio
        end
      end

      def vixel_count
        vixels.length
      end
    end
  end
end
