# frozen_string_literal: true

module Vissen
  module Output
    # Pixel
    #
    # TODO: How do we want the pixel to saturate? When written or when read?
    class Pixel < Color
      def clear!
        @r = @g = @b = 0
      end

      def inspect
        format '(%.1f, %.1f, %.1f)', @r, @g, @b
      end
    end
  end
end
