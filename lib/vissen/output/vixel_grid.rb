module Vissen
  module Output
    # Vixel Grid
    #
    #
    class VixelGrid
      extend  Forwardable
      include Grid

      attr_reader :palettes, :layers

      alias vixel_count grid_points

      def initialize(rows, columns, layer_count, palettes, **args)
        super(rows, columns, **args)

        raise RangeError if layer_count <= 0
        raise ArgumentError unless palettes.is_a?(Array) && !palettes.empty?
        raise TypeError unless palettes.all? { |pa| pa.respond_to?(:[]) }

        @palettes = palettes
        @layers   = Array.new(layer_count) { Layer.new self }

        freeze
      end

      # Freeze
      #
      # Prevents any more layers and palettes from being added.
      def freeze
        @palettes.freeze
        @layers.freeze
        super
      end

      # Vixel Accessor
      #
      # Returns the vixel at the given layer, row and column
      def [](layer, row, column)
        @layers[layer][row, column]
      end

      # Pixel Grid
      #
      # Create a matching pixel grid that share the same number of rows, columns
      # and aspect ratio.
      def pixel_grid
        PixelGrid.new rows, columns, aspect_ratio: width / height
      end

      # Render
      #
      # Renders each layer and combines the result in the given buffer.
      def render(pixel_grid, intensity: 1.0)
        raise TypeError unless self === pixel_grid

        pixel_grid.clear!

        @layers.reduce(pixel_grid.pixels) do |a, e|
          e.render a, intensity: intensity
        end
      end
    end
  end
end
