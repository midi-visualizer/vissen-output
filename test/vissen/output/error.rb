# frozen_string_literal: true

module Vissen
  module Output
    # The Output Error base class must be the parent of all other custom error
    # classes created in this library. From [ruby-doc](https://ruby-doc.org/core-2.5.0/Exception.html):
    #
    #   It is recommended that a library should have one subclass of
    #   StandardError or RuntimeError and have specific exception types inherit
    #   from it. This allows the user to rescue a generic exception type to
    #   catch all exceptions the library may raise even if future versions of
    #   the library add new exception subclasses.
    #
    class Error < StandardError
    end
  end
end
