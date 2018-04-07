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

      def clear!
        pixels.each(&:clear!)
      end
    end
  end
end
