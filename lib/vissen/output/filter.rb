# frozen_string_literal: true

module Vissen
  module Output
    # Filter
    #
    #
    module Filter
      attr_reader :context

      def initialize(context)
        raise TypeError unless context.is_a? Context

        @context = context
      end

      def apply(_pixel_cloud)
        raise NotImplementedError
      end
    end
  end
end
