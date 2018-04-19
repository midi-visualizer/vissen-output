# frozen_string_literal: true

require 'forwardable'

module Vissen
  module Output
    # Buffer
    #
    #
    module Buffer
      extend Forwardable

      # @return [Context] the context of the buffer.
      attr_reader :context

      # @return [Object] the elements at the buffer points.
      attr_reader :elements

      def_delegators :@context, :width, :height
      def_delegators :@elements, :each, :each_with_index

      # The grid is setup with a grid context as well as a class to places
      # instances of in every grid point.
      #
      # @raise  [ArgumentError] if both an element class and a block are given.
      #
      # @param  context [Context] the context in which the buffer exists.
      # @param  elements_klass [Class] the class to use when allocating
      #   elements.
      # @param  block [Proc] the block to use instead of `elements_klass` when
      #   allocating element objects.
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

      # Prevents the context and element array from being changed.
      #
      # @return [self]
      def freeze
        @elements.freeze
        super
      end

      # Context specific element accessor. Depends on `Context#index_from` to
      # transform `args` into an index.
      #
      # @param  args (see Context#index_from).
      # @return [Object] the element at the given index.
      def [](*args)
        @elements[@context.index_from(*args)]
      end

      # Iterates over each element in the buffer and yields the element along
      # with its x and y coordinates.
      #
      # @return (see Context#each_position).
      def each_with_position
        return to_enum(__callee__) unless block_given?
        @context.each_position { |i, x, y| yield @elements[i], x, y }
      end

      # Two buffers are considered equal if they share the same context.
      #
      # @param  other [#context, Object]
      # @return [true, false] true if the other object share the same context.
      def share_context?(other)
        @context == other.context
      rescue NoMethodError
        false
      end

      alias === share_context?
    end
  end
end
