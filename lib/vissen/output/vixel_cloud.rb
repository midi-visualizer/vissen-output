# frozen_string_literal: true

module Vissen
  module Output
    # Vixel Cloud
    #
    # TODO: Document this class.
    class VixelCloud
      include Buffer

      # @return [Float] the global intensity of the cloud.
      attr_accessor :intensity

      # @return [Integer] the palette number currently in use.
      attr_accessor :palette

      # @!method vixels
      # @return [Array<Vixel>] an array with the `Vixel` objects in the cloud.
      alias vixels elements

      # @param  context [Context] the context in which the cloud exists.
      # @param  palette [Integer] the palette number to use when rendering.
      # @param  intensity [Float] the global intensity at which to render.
      def initialize(context, palette: 0, intensity: 1.0)
        super(context, Vixel)

        @palette   = palette
        @intensity = intensity
      end

      # Render the layer vixels to the given buffer.
      #
      # @param  buffer [PixelCloud] the buffer to store the resulting colors of
      #   each point in.
      # @param  intensity [Float] the intensity to scale the vixels intensity
      #   with.
      # @return [PixelCloud] the same cloud that was given as a parameter.
      def render(buffer, intensity: 1.0)
        palette = context.palettes[@palette]
        buffer.each_with_index do |color, index|
          vixel = vixels[index]
          next unless vixel.i.positive?

          ratio = vixel.i * intensity * @intensity
          color.mix_with! palette[vixel.p], ratio
        end
        buffer
      end

      # @return [Integer] the number of vixels in the cloud.
      def vixel_count
        vixels.length
      end
    end
  end
end
