# frozen_string_literal: true

module Vissen
  module Output
    # The pixel cloud is an implementation of the general `Cloud` module that
    # places `Pixel` objects in each cloud point.
    class PixelCloud
      include Cloud

      # @!method pixels
      # @return [Pixel] the pixels in the cloud.
      alias pixels elements

      # @param  context [Context] the context in which the pixel cloud exists.
      def initialize(context)
        super context, Pixel
        freeze
      end

      # Replaces the pixel values of this buffer with those of the given object.
      #
      # @param  other [PixelCloud] the pixel cloud to copy values from.
      def copy!(other)
        raise TypeError unless other.is_a? self.class

        other.each_with_index do |src_pixel, index|
          dst_pixel = pixels[index]

          dst_pixel.r = src_pixel.r
          dst_pixel.g = src_pixel.g
          dst_pixel.b = src_pixel.b
        end
      end

      # Zeros the rbg components of each pixel in the buffer.
      def clear!
        pixels.each(&:clear!)
      end
    end
  end
end
