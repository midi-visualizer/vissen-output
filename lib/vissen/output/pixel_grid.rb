module Vissen
  module Output
    # Pixel Grid
    #
    #
    class PixelGrid
      extend  Forwardable
      include Grid

      attr_reader :pixels

      def_delegators :@pixels, :[], :each

      def initialize(*)
        super

        @pixels = alloc_points(Pixel).freeze
        freeze
      end

      def clear!
        @pixels.each(&:clear!)
      end
    end
  end
end
