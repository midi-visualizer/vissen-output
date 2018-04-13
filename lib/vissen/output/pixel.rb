# frozen_string_literal: true

module Vissen
  module Output
    # The `Pixel` object is used by the `PixelBuffer` to store the colors of its
    # points.
    #
    # TODO: How do we want the pixel to saturate? When written or when read?
    class Pixel < Color
      # Reset the pixel color to black (0, 0, 0).
      #
      # @return [self]
      def clear!
        self.r = 0
        self.g = 0
        self.b = 0
        self
      end

      # @return [String] a string representation of the pixel.
      def inspect
        format '(%.1f, %.1f, %.1f)', r, g, b
      end
    end
  end
end
