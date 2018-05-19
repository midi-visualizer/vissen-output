# frozen_string_literal: true

module Vissen
  module Output
    # The `Vixel` (Vissen pixel) represents the two dimensional representation
    # of each grid pixel, for each grid. Each vixel has an intensity (i) and a
    # palette position (p), both with values in the range 0..1.
    #
    # TODO: How do we want the vixel to saturate? When written or when read?
    class Vixel
      # @return [Float] the vixel intensity.
      attr_accessor :i

      # @return [Float] the vixel palette position.
      attr_accessor :p

      # @param  i [Numeric] the vixel intensity.
      # @param  p [Numeric] the vixel palette position.
      def initialize(i = 0.0, p = 0.0)
        self.i = i
        self.p = p
      end

      # @param  other [Object] the object to check equality against.
      # @return [true,false] true if the other object has the same intensity and
      #   palette position.
      def ==(other)
        @i == other.i && @p == other.p
      rescue NoMethodError
        false
      end

      # @return [String] a string representation of the vixel.
      def inspect
        format '(%.1f, %.1f)', @i, @p
      end
    end
  end
end
