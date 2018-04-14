# frozen_string_literal: true

module Vissen
  module Output
    # The pixel buffer is an implementation of the general `Buffer` module that
    # places `Pixel` objects in each buffer element.
    class PixelBuffer
      include Buffer

      # @!method pixels
      # @return [Pixel] the pixels in the buffer.
      alias pixels elements

      # @raise  [ContextError] if any of the filters does not share the same
      #   context.
      #
      # @param  context [Context] the context in which the pixel buffer exists.
      # @param  filters [Array<Filter>] the output filters to apply when
      #   finalizing the buffer.
      def initialize(context, filters = [])
        super context, Pixel
        # Verify that all filters share the same context
        # before adding them.
        filters.each { |f| raise ContextError unless self === f }
        @filters = filters

        freeze
      end

      # Prevent any more filters from being added.
      #
      # @return [self]
      def freeze
        @filters.freeze
        super
      end

      # Zeros the RGB components of each pixel in the buffer.
      def clear!
        pixels.each(&:clear!)
      end

      # Replaces the pixel values of this buffer with those of the given object.
      #
      # @raise  [TypeError] if the other object is not a PixelBuffer.
      #
      # @param  other [PixelBuffer] the pixel buffer to copy values from.
      def copy!(other)
        raise TypeError unless other.is_a? self.class

        other.each_with_index do |src_pixel, index|
          dst_pixel = pixels[index]

          dst_pixel.r = src_pixel.r
          dst_pixel.g = src_pixel.g
          dst_pixel.b = src_pixel.b
        end
      end

      # Signals to the `PixelBuffer` that the user is done updating the color
      # values and that the buffer should perform any post processing that is
      # needed.
      #
      # @return [self]
      def finalize!
        @filters.each { |filter| filter.apply self }
        self
      end
    end
  end
end
