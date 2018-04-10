# frozen_string_literal: true

module Vissen
  module Output
    # Vixel
    #
    # The Vixel (Vissen pixel) represents the two dimensional representation of
    # each grid pixel, for each grid. Each vixel has a palette position (p) and
    # an intensity (i), both in the range 0..1.
    #
    # TODO: How do we want the vixel to saturate? When written or when read?
    class Vixel
      attr_reader :i, :p

      def initialize(p = 0.0, i = 0.0)
        self.p = p
        self.i = i
      end

      def ==(other)
        @p == other.p && @i == other.i
      end

      def p=(value)
        @p = self.class.truncate value
      end

      def i=(value)
        @i = self.class.truncate value
      end

      def inspect
        format '(%.1f, %.1f)', @p, @i
      end

      class << self
        # Makes sure n is in the range 0..1
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
