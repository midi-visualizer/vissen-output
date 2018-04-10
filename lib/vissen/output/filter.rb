# frozen_string_literal: true

module Vissen
  module Output
    # Filter
    #
    #
    module Filter
      attr_reader :context

      def initialize(grid_context)
        raise TypeError unless grid_context.is_a? GridContext

        @context = grid_context
      end

      def apply(_pixel_cloud)
        raise NotImplementedError
      end
    end
  end
end
