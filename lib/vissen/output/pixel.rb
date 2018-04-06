module Vissen
  module Output
    # Pixel
    #
    #
    class Pixel
      attr_accessor :r, :g, :b

      def initialize(r = 0.0, g = 0.0, b = 0.0)
        @r = r
        @g = g
        @b = b
      end

      def clear!
        @r = @g = @b = 0
      end

      def inspect
        format '(%.1f, %.1f, %.1f)', @r, @g, @b
      end
    end
  end
end
