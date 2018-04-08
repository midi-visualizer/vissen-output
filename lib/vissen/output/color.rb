module Vissen
  module Output
    # Color
    #
    # Basic value object representing a color in the RGB color space.
    class Color
      attr_accessor :r, :g, :b

      def initialize(r = 0.0, g = 0.0, b = 0.0)
        @r = r
        @g = g
        @b = b
      end

      # To Array
      #
      # Returns a new array containing the red, green and blue color values.
      def to_a
        [@r, @g, @b]
      end

      # Mix With (destructive)
      #
      # Moves this color toword the other based on the given ratio.
      #
      # ratio = 0 -> 100 % of this color
      # ratio = 1 -> 100 % of the other color
      def mix_with!(other, ratio)
        @r = @r * (1 - ratio) + other.r * ratio
        @g = @g * (1 - ratio) + other.g * ratio
        @b = @b * (1 - ratio) + other.b * ratio

        self
      end

      # Mix With
      #
      # Returns a new color that is a mix between this and the other color,
      # based on the ratio. See #mix_with! for more details.
      def mix_with(other, ratio)
        dup.mix_with! other, ratio
      end

      # Inspect
      #
      # Returns a string formatted in the tradiotioal hex representation of a
      # color: #04A4BF.
      def inspect
        format('#%02X%02X%02X', *to_a.map! { |v| (v * 255).round })
      end

      class << self
        # From
        #
        # Cast a given object to a color.
        def from(obj)
          case obj
          when self then obj
          when Array then new(*obj)
          else
            new(*obj.to_a)
          end
        end
      end
    end
  end
end
