# frozen_string_literal: true

module Vissen
  module Output
    # Pixel Cloud
    #
    #
    class PixelCloud
      include Grid

      alias pixels elements

      def initialize(context)
        super context, Pixel
        freeze
      end

      # Copy!
      #
      # Replaces the pixel values of this buffer with those of the given object.
      def copy!(other)
        raise TypeError unless other.is_a? self.class

        other.each_with_index do |src_pixel, index|
          dst_pixel = pixels[index]

          dst_pixel.r = src_pixel.r
          dst_pixel.g = src_pixel.g
          dst_pixel.b = src_pixel.b
        end
      end

      # Clear!
      #
      # Zeros the rbg components of each pixel in the buffer.
      def clear!
        pixels.each(&:clear!)
      end
    end
  end
end
