# frozen_string_literal: true

module Vissen
  module Output
    # Pixel Grid
    #
    #
    class PixelGrid
      include Grid

      alias pixels elements

      def initialize(context)
        super context, Pixel
        freeze
      end

      def copy!(other)
        raise TypeError unless other.is_a? PixelGrid

        other.each_with_index do |src_pixel, index|
          dst_pixel = pixels[index]

          dst_pixel.r = src_pixel.r
          dst_pixel.g = src_pixel.g
          dst_pixel.b = src_pixel.b
        end
      end

      def clear!
        pixels.each(&:clear!)
      end
    end
  end
end
