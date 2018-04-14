# frozen_string_literal: true

require 'vissen/output/version'

require 'vissen/output/error'
require 'vissen/output/context_error'
require 'vissen/output/color'
require 'vissen/output/filter'
require 'vissen/output/filter/quantizer'
require 'vissen/output/filter/gamma'
require 'vissen/output/pixel'
require 'vissen/output/point'
require 'vissen/output/vixel'
require 'vissen/output/palette'
require 'vissen/output/palettes'
require 'vissen/output/buffer'
require 'vissen/output/context'
require 'vissen/output/context/cloud'
require 'vissen/output/context/circle'
require 'vissen/output/context/grid'
require 'vissen/output/pixel_buffer'
require 'vissen/output/vixel_buffer'
require 'vissen/output/vixel_stack'

module Vissen
  # The main job of the output module is to transform a multi layered collection
  # of `Vixel` objects, a `VixelBuffer`, into a single layered collection of
  # `Pixel`objects, a `PixelBuffer`.
  module Output
  end
end
