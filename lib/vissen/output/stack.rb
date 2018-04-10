# frozen_string_literal: true

require 'forwardable'

module Vissen
  module Output
    # Stack
    #
    #
    class Stack
      extend Forwardable

      attr_reader :layers, :context

      def_delegators :@context, :point_count

      alias vixel_count point_count

      # Initialize
      #
      # TODO: Make palettes a keyword argument in the next minor version.
      def initialize(context, layer_count)
        raise RangeError if layer_count <= 0

        @context = context
        @layers  = Array.new(layer_count) { VixelCloud.new context }

        freeze
      end

      # Freeze
      #
      # Prevents any more layers and palettes from being added.
      def freeze
        @layers.freeze
        super
      end

      # Vixel Accessor
      #
      # Returns the vixel at the given layer.
      def [](layer, *args)
        @layers[layer][*args]
      end

      # Pixel Cloud
      #
      # Returns a new, uninitialized pixel cloud.
      def pixel_cloud
        PixelCloud.new context
      end

      # Render
      #
      # Renders each layer and combines the result in the given buffer.
      #
      # TODO: Could we cache the result of this operation at time t to an
      #       internal PixelGrid and copy the stored information for subsequent
      #       requests at or around the same time?
      def render(pixel_cloud, intensity: 1.0)
        raise TypeError unless context == pixel_cloud.context

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
