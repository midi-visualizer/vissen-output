# frozen_string_literal: true

module Vissen
  module Output
    # The Palette is, at its core, a transformation between a position (0..1)
    # and a color value \\{(0..1) x 3\\}. It can either be continous or be based
    # on a pre-allocated lookup table.
    #
    # == Usage
    # The following example creates a continuous palette and acesses the color
    # at index 0.42.
    #
    #   palette = Palette.new 0x11998e, 0x38ef7d, label: 'Quepal'
    #   palette[0.42] => #21BD87
    #
    # A discrete palette can also be created by specifying the number of steps
    # to use.
    #
    #   palette = Palette.new 0x11998e, 0x38ef7d, steps: 5
    #   palette[0.42] => #1BAF8A
    #
    class Palette
      # @return [String, nil] the optional palette label.
      attr_reader :label

      # @param  colors [Array<Color>, Array<#to_a>] the colors to use in the
      #   palette.
      # @param  steps [Integer] the number of discrete palette values. The
      #   palette will be continuous if nil.
      # @param  label [String] the optional label to use when identifying the
      #   palette.
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

      # Prevents both the palette colors and the label from changing.
      #
      # @return [self]
      def freeze
        @colors.freeze
        @label.freeze

        super
      end

      # @param  steps [Fixnum] the number of discrete colors in the new palette.
      # @return [Palette] a new, discrete palette.
      def discretize(steps)
        self.class.new(*@colors, steps: steps, label: @label)
      end

      # Discretize the palette into the given number of values. Palettes defined
      # with a step count are sampled as if they where continuous.
      #
      # @param  n [Integer] the number of discrete values to produce.
      # @return [Array<Color>] an array of colors sampled from the palette.
      def to_a(n)
        Array.new(n) { |i| color_at(i.to_f / (n - 1)).freeze }
      end

      # Example output:
      #   "#42BEAF -> #020180 (rainbow)"
      #
      # @return [String] a string representation of the palette made up of the
      #   palette colors as well as the (optional) label.
      def inspect
        @colors.map(&:inspect).join(' -> ').tap do |base|
          break "#{base} (#{@label})" if @label
        end
      end

      private

      def define_discrete_accessor(steps)
        @palette = to_a(steps).freeze
        last_color_index = @palette.length - 1
        define_singleton_method :[] do |index|
          index = if index >= 1.0 then last_color_index
                  elsif index < 0.0 then 0
                  else (index * last_color_index).floor
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
