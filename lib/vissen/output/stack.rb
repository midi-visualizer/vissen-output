module Vissen
  module Output
    # Stack
    #
    #
    class Stack
      include GridContext

      attr_reader :palettes, :layers

      alias vixel_count grid_points

      # Initialize
      #
      # TODO: Make palettes a keyword argument in the next minor version.
      def initialize(rows, columns, layer_count, palettes = PALETTES, **args)
        super(rows, columns, **args)

        raise RangeError if layer_count <= 0
        raise ArgumentError unless palettes.is_a?(Array) && !palettes.empty?
        raise TypeError unless palettes.all? { |pa| pa.respond_to?(:[]) }

        @palettes = palettes
        @layers   = Array.new(layer_count) { VixelGrid.new self }

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
      # Returns a new, uninitialized pixel grid.
      def pixel_grid
        PixelGrid.new self
      end

      # Render
      #
      # Renders each layer and combines the result in the given buffer.
      #
      # TODO: Could we cache the result of this operation at time t to an
      #       internal PixelGrid and copy the stored information for subsequent
      #       requests at or around the same time?
      def render(pixel_grid, intensity: 1.0)
        raise TypeError unless self == pixel_grid.context

        pixel_grid.clear!

        @layers.reduce(pixel_grid) do |a, e|
          e.render a, intensity: intensity
        end

        # TODO: Apply filters to pixel_grid. Perhaps through
        #       pixel_grid.finalize! or something similar.
      end
    end
  end
end
