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
      attr_reader :i

      # @return [Float] the vixel palette position.
      attr_reader :p

      # @param  i [Float] the vixel intensity.
      # @param  p [Float] the vixel palette position.
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

      # @param  value [Float] the new intensity value.
      # @return [Float] the truncated intensity value.
      def i=(value)
        @i = self.class.truncate value
      end

      # @param  value [Float] the new palette position.
      # @return [Float] the truncated palette position.
      def p=(value)
        @p = self.class.truncate value
      end

      # @return [String] a string representation of the vixel.
      def inspect
        format '(%.1f, %.1f)', @i, @p
      end

      class << self
        # Makes sure n is in the range 0..1.
        #
        # @param  n [Float] the value to truncate.
        # @return [Float] n truncated to fit within the range 0..1.
        def truncate(n)
          if n <= 0    then 0.0
          elsif n >= 1 then 1.0
          else              n
          end
        end
      end
    end
  end
end
