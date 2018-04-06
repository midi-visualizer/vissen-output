require 'forwardable'

module Vissen
  module Output
    # Layer
    #
    # The layer is a fundemental building block in the visualizer graphics
    # chain. It holds the state of each vixel in the layer as well as the
    # palette that should be used to render them.
    #
    # Layers can also have time dependent effects that operate on the layer
    # vixels. The effects will be called in the order they where originally
    # added.
    class Layer
      extend Forwardable

      attr_accessor :intensity
      attr_reader   :vixels

      def_delegators :@vixels, :each, :each_with_index, :[], :length
      alias vixel_count length

      def initialize(grid, intensity: 1.0)
        @grid      = grid
        @vixels    = grid.alloc_points(Vixel).freeze
        @intensity = intensity
      end

      # Render
      #
      # Render the layer vixels to the given buffer.
      def render(buffer, intensity: 1.0)
        buffer.each_with_index do |color, index|
          vixel = @vixels[index]
          next unless vixel.i > 0

          ratio = vixel.i * intensity * @intensity
          self.class.mix_color color, @grid.palettes[vixel.p][vixel.q], ratio
        end
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
