# frozen_string_literal: true

module Vissen
  module Output
    # An output filter is defined as a time invariant operation on a pixel
    # cloud. Upon initialization the filter is given the output context as a
    # chance to precompute some results. The rest of the work is done in
    # `#apply` and should not depend on time.
    module Filter
      attr_reader :context

      # @param  context [Context] the context within which the filter will be
      #   applied.
      def initialize(context)
        raise TypeError unless context.is_a? Context

        @context = context
      end

      # @param  _pixel_cloud [PixelCloud] the pixel cloud to which the filter
      #   should be applied.
      def apply(_pixel_cloud)
        raise NotImplementedError
      end
    end
  end
end
