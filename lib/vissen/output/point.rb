# frozen_string_literal: true

module Vissen
  module Output
    # Point
    #
    #
    class Point
      attr_reader :position

      alias to_a position

      def initialize(x, y, scale: 1.0)
        @position = [x * scale, y * scale]
      end

      def freeze
        @position.freeze
        super
      end

      class << self
        def from(obj)
          return obj if obj.is_a? self
          new(*obj.to_a)
        end
      end
    end
  end
end
