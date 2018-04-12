# frozen_string_literal: true

require 'forwardable'

module Vissen
  module Output
    # Stack
    #
    # TODO: Document this class.
    class VixelStack
      extend Forwardable

      # @return [Array<VixelCloud>] the layers that make up the stack.
      attr_reader :layers

      # @return [Context] the context in which the stack exist.
      attr_reader :context

      # @!method point_count
      # @return [Integer] the number of points in each layer of the stack.
      def_delegators :@context, :point_count

      alias vixel_count point_count

      # TODO: Make palettes a keyword argument in the next minor version.
      #
      # @raise  [RangeError] if layer_count <= 0.
      #
      # @param  context [Context] the context in which the stack exist.
      # @param  layer_count [Integer] the number of layers in the stack.
      def initialize(context, layer_count)
        raise RangeError if layer_count <= 0

        @context = context
        @layers  = Array.new(layer_count) { VixelCloud.new context }

        freeze
      end

      # Prevents more layers and palettes from being added.
      #
      # @return [self]
      def freeze
        @layers.freeze
        super
      end

      # @param  layer [Integer] the index of the layer that is accessed.
      # @param  args (see VixelCloud#[])
      # @return [Vixel,nil] the vixel at the given layer.
      def [](layer, *args)
        @layers[layer][*args]
      end

      # @return [PixelCloud] a new, uninitialized pixel cloud.
      def pixel_cloud
        PixelCloud.new context
      end

      # Renders each layer and combines the result in the given buffer.
      #
      # TODO: Could we cache the result of this operation at time t to an
      #       internal PixelGrid and copy the stored information for subsequent
      #       requests at or around the same time?
      #
      # @raise  [TypeError] if the pixel cloud does not share the same context.
      #
      # @param  pixel_cloud [PixelCloud] the buffer to store the resulting
      #   colors of each point in.
      # @param  intensity [Float] the intensity to scale the vixels intensity
      #   with.
      # @return [PixelCloud] the same cloud that was given as a parameter.
      def render(pixel_cloud, intensity: 1.0)
        raise TypeError unless context == pixel_cloud.context

        pixel_cloud.clear!

        @layers.reduce(pixel_cloud) do |a, e|
          e.render a, intensity: intensity
        end

        # TODO: Apply filters to pixel_cloud. Perhaps through
        #       pixel_cloud.finalize! or something similar.

        pixel_cloud
      end
    end
  end
end
