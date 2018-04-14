# frozen_string_literal: true

module Vissen
  module Output
    # Context errors occur when two components of the output stack are used
    # together even though they do not share the same context.
    class ContextError < Error
      def initialize(msg = 'The context of the given object does not match')
        super
      end
    end
  end
end
