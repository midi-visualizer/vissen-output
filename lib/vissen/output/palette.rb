module Vissen
  module Output
    # Palette
    #
    # The Palette is, at its core, a transformation between a position (0..1)
    # and a pixel value {(0..1) x 3}. It can either be continous or be based on
    # a preallocated lookup table.
    class Palette
      attr_reader :label

      def initialize(*colors, steps: nil, label: nil)
        @colors = colors.map { |c| c.to_a.freeze }
        @label  = label

        if steps
          define_discrete_accessor steps
        else
          define_continous_accessor
        end

        freeze
      end

      def freeze
        @colors.freeze
        @label.freeze

        super
      end

      def to_a(n)
        Array.new(n) { |i| color_at(i.to_f / (n - 1)).freeze }
      end

      private

      def define_discrete_accessor(steps)
        @palette = to_a steps
        define_singleton_method :[] do |index|
          index = if index >= 1.0 then @palette.length - 1
                  elsif index < 0.0 then 0
                  else (index * (@palette.length - 1)).floor
                  end

          @palette[index]
        end
      end

      def define_continous_accessor
        define_singleton_method(:[]) { |pos| color_at pos }
      end

      def color_bin(pos)
        num_bins     = (@colors.length - 1)
        bin          = (pos * num_bins).floor
        mixing_ratio = pos * num_bins - bin

        [bin, mixing_ratio]
      end

      def color_at(pos)
        return Pixel.new(*@colors[0]) if pos <= 0
        return Pixel.new(*@colors[-1]) if pos >= 1

        # Find the two colors we are between
        bin, r = color_bin pos
        a, b = @colors[bin, 2]
        self.class.mix_ab a, b, r
      end

      class << self
        # Mix color A with color B
        #
        # r = 0 -> 100 % of color A
        # r = 1 -> 100 % of color B
        def mix_ab(a, b, r)
          Pixel.new(
            *a.map.with_index { |e, i| e * (1 - r) + b[i] * r }
          )
        end
      end
    end
  end
end
