module Vissen
  module Output
    # Palette
    #
    # The Palette is, at its core, a transformation between a position (0..1)
    # and a color value {(0..1) x 3}. It can either be continous or be based on
    # a pre-allocated lookup table.
    class Palette
      attr_reader :label

      def initialize(*colors, steps: nil, label: nil)
        @colors = colors.map { |c| Color.from(c).freeze }
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

      # To Array
      #
      # Discretize the palette into the given number of values. Palettes defined
      # with a step count are sampled as if they where continuous.
      def to_a(n)
        Array.new(n) { |i| color_at(i.to_f / (n - 1)).freeze }
      end

      def inspect
        @colors.map(&:inspect).join(' -> ').tap do |base|
          break "#{base} (#{@label})" if @label
        end
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
        return @colors[0]  if pos <= 0
        return @colors[-1] if pos >= 1

        # Find the two colors we are between
        bin, r = color_bin pos
        a, b = @colors[bin, 2]
        a.mix_with b, r
      end
    end
  end
end
