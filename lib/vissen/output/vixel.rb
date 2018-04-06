module Vissen
  module Output
    # Vixel
    #
    # The Vixel (Vissen pixel) represents the two dimensional representation of
    # each grid pixel, for each layer. Each vixel has a palette value (p), a
    # palette position (q) and an intensity (i). The first is an integer while
    # the last two both lie in the range 0..1.
    #
    # TODO: How do we want the vixel to saturate? When written or when read?
    class Vixel
      attr_accessor :p
      attr_reader :i, :q

      def initialize(p = 0, q = 0.0, i = 0.0)
        self.p = p
        self.q = q
        self.i = i
      end

      def q=(value)
        @q = self.class.truncate value
      end

      def i=(value)
        @i = self.class.truncate value
      end

      def inspect
        format '(%d | %.1f, %.1f)', @p, @q, @i
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
