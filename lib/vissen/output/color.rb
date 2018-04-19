# frozen_string_literal: true

module Vissen
  module Output
    # Basic value object representing a color in the RGB color space.
    #
    # == Usage
    # The following example creates two colors, mixes them, and converts the
    # result to an array of color component.
    #
    #   color_a = Color.new 0.3, 0.6, 0.2
    #   color_b = Color.new 0.1, 0.2, 0.5
    #
    #   color_a.mix_with(color_b, 0.5).to_a => [0.2, 0.3, 0.35]
    #
    class Color
      attr_accessor :r, :g, :b

      # @param  r [Float] the red color value in the range (0..1).
      # @param  g [Float] the green color value in the range (0..1).
      # @param  b [Float] the blue color value in the range (0..1).
      def initialize(r = 0.0, g = 0.0, b = 0.0)
        @r = r
        @g = g
        @b = b
      end

      # Color equality based on component values.
      #
      # TODO: Add some small delta around what is considered the same color?
      #       Perhaps scale to 255 and floor before comparing?
      #
      # @param  other [Object] the object to check equality against.
      # @return [true, false] true when two colors are exactly the same.
      def ==(other)
        r == other.r && g == other.g && b == other.b
      rescue NoMethodError
        false
      end

      # Creates a new array from the color.
      #
      # @return [Array<Float>] a new array containing the red, green and blue
      #   color values.
      def to_a
        [r, g, b]
      end

      # rubocop:disable Metrics/AbcSize

      # Moves this color toword the other based on the given ratio.
      #
      # ratio = 0 -> 100 % of this color
      # ratio = 1 -> 100 % of the other color
      #
      # @param  other [Color] the color to mix with
      # @param  ratio [Float] the amount (0..1) of the other color to mix in.
      # @return [self]
      def mix_with!(other, ratio)
        anti_ratio = (1 - ratio)

        self.r = r * anti_ratio + other.r * ratio
        self.g = g * anti_ratio + other.g * ratio
        self.b = b * anti_ratio + other.b * ratio

        self
      end
      # rubocop:enable Metrics/AbcSize

      # Returns a new color that is a mix between this and the other color,
      # based on the ratio. See `#mix_with!` for more details.
      #
      # @param  (see #mix_with!)
      # @return [Color] the result of the mix.
      def mix_with(other, ratio)
        dup.mix_with! other, ratio
      end

      # Returns a string formatted in the tradiotioal hex representation of a
      # color: #04A4BF.
      #
      # @return [String] the object string representation.
      def inspect
        format('#%02X%02X%02X', *to_a.map! { |v| (v * 255).round })
      end

      class << self
        # Cast a given object to a color.
        #
        # @param  obj [Color, Array<Numeric>, Integer, #to_a] the object to
        #   coerce.
        # @return [Color] a new color object.
        def from(obj)
          case obj
          when self    then obj
          when Array   then new(*obj)
          when Integer then from_integer obj
          else
            new(*obj.to_a)
          end
        end

        private

        def from_integer(int)
          b = (int & 0xFF) / 255.0
          int >>= 8
          g = (int & 0xFF) / 255.0
          int >>= 8
          r = (int & 0xFF) / 255.0

          new r, g, b
        end
      end
    end
  end
end
