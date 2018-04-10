# frozen_string_literal: true

require 'forwardable'

module Vissen
  module Output
    # Cloud
    #
    #
    module Cloud
      extend Forwardable
      attr_reader :context, :elements

      def_delegators :@context, :width, :height
      def_delegators :@elements, :each, :each_with_index, :[]

      # Initialize
      #
      # The grid is setup with a grid context as well as a class to places
      # instances of in every grid point.
      def initialize(context, elements_klass = nil, &block)
        @context  = context
        @elements =
          if block_given?
            raise ArgumentError if elements_klass
            context.alloc_points(&block).freeze
          else
            context.alloc_points(elements_klass).freeze
          end
      end

      def each_with_position
        return to_enum(__callee__) unless block_given?
        @context.each_position { |i, x, y| yield @elements[i], x, y }
      end

      # Grid Likeness
      #
      # Two grids are considered equal if they share the same context.
      def ===(other)
        @context == other.context
      rescue NoMethodError
        false
      end
    end
  end
end
