# frozen_string_literal: true

module Vissen
  module Output
    # Stack
    #
    #
    class Stack
      include GridContext

      attr_reader :palettes, :layers

      alias vixel_count point_count

      # Initialize
      #
      # TODO: Make palettes a keyword argument in the next minor version.
      def initialize(rows, columns, layer_count, palettes = PALETTES, **args)
        super(rows, columns, **args)

        raise RangeError if layer_count <= 0
        raise ArgumentError unless palettes.is_a?(Array) && !palettes.empty?
        raise TypeError unless palettes.all? { |pa| pa.respond_to?(:[]) }

        @palettes = palettes
        @layers   = Array.new(layer_count) { VixelCloud.new self }

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

      # Pixel Cloud
      #
      # Returns a new, uninitialized pixel cloud.
      def pixel_cloud
        PixelCloud.new self
      end

      # Render
      #
      # Renders each layer and combines the result in the given buffer.
      #
      # TODO: Could we cache the result of this operation at time t to an
      #       internal PixelGrid and copy the stored information for subsequent
      #       requests at or around the same time?
      def render(pixel_cloud, intensity: 1.0)
        raise TypeError unless self == pixel_cloud.context

        pixel_cloud.clear!

        @layers.reduce(pixel_cloud) do |a, e|
          e.render a, intensity: intensity
        end

        # TODO: Apply filters to pixel_cloud. Perhaps through
        #       pixel_cloud.finalize! or something similar.
      end
    end
  end
end
