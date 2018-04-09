# frozen_string_literal: true

module Vissen
  module Output
    # Default palette collection.
    PALETTES = {
      'Argon'      => [0x03001e, 0x7303c0, 0xec38bc, 0xfdeff9],
      'Red Sunset' => [0x355c7d, 0x6c5b7b, 0xc06c84],
      'Quepal'     => [0x11998e, 0x38ef7d]
    }.map { |l, c| Palette.new(*c, label: l) }.freeze
  end
end
