# frozen_string_literal: true

require 'vissen/output/version'

require 'vissen/output/color'
require 'vissen/output/filter'
require 'vissen/output/filter/quantizer'
require 'vissen/output/filter/gamma'
require 'vissen/output/pixel'
require 'vissen/output/point'
require 'vissen/output/vixel'
require 'vissen/output/palette'
require 'vissen/output/palettes'
require 'vissen/output/context'
require 'vissen/output/cloud'
require 'vissen/output/context/cloud'
require 'vissen/output/context/circle'
require 'vissen/output/context/grid'
require 'vissen/output/grid' # TODO: Depricate or find use for.
require 'vissen/output/pixel_cloud'
require 'vissen/output/vixel_cloud'
require 'vissen/output/vixel_stack'

module Vissen
  # The main job of the output module is to transform a multi layered collection
  # of `Vixel` objects, a `VixelCloud`, into a single layered collection of
  # `Pixel`objects, a `PixelCloud`.
  module Output
  end
end
