# frozen_string_literal: true

require 'test_helper'

describe Vissen::Output::Stack do
  subject { Vissen::Output::Stack }

  let(:rows)        { 2 }
  let(:columns)     { 3 }
  let(:layer_count) { 2 }
  let(:colors) do
    [
      Color::RGB.new(0xFF, 0, 0),
      Color::RGB.new(0, 0xFF, 0),
      Color::RGB.new(0, 0, 0xFF)
    ]
  end
  let(:palettes) do
    [
      Vissen::Output::Palette.new(*colors),
      Vissen::Output::Palette.new(*colors.reverse)
    ]
  end
  let(:context_klass) { Vissen::Output::GridContext }
  let(:context)       { context_klass.new rows, columns, palettes: palettes }
  let(:stack)         { subject.new context, layer_count }

  describe '.new' do
    it 'raises a RangeError when layer_count <= 0' do
      assert_raises(RangeError) do
        subject.new context, 0
      end
    end
  end

  describe '#[]' do
    it 'returns a vixel' do
      assert_kind_of Vissen::Output::Vixel, stack[0, 0, 0]
    end

    it 'returns the correct vixel' do
      layer  = rand layer_count
      row    = rand rows
      column = rand columns
      index  = stack.context.index_from row, column
      vixel  = stack.layers[layer].vixels[index]

      assert_equal vixel, stack[layer, row, column]
    end
  end

  describe '#pixel_cloud' do
    it 'returns a pixel grid of the same size' do
      pixel_cloud = stack.pixel_cloud

      assert_kind_of Vissen::Output::PixelCloud, pixel_cloud
      assert_equal stack.context.rows,    pixel_cloud.context.rows
      assert_equal stack.context.columns, pixel_cloud.context.columns
      assert_equal stack.context.width,   pixel_cloud.width
      assert_equal stack.context.height,  pixel_cloud.height
    end
  end

  describe '#render' do
    let(:pixel_cloud) { stack.pixel_cloud }
    let(:pixels)      { pixel_cloud.pixels }

    before do
      # Randomize the vixels
      stack.layers.each do |layer|
        layer.each do |vixel|
          vixel.p = rand
          vixel.i = rand
        end
      end
    end

    it 'renders the vixels to a pixel grid' do
      stack.render(pixel_cloud)

      pixels.each_with_index do |pixel, index|
        v_bg = stack.layers[0].vixels[index]
        v_fg = stack.layers[1].vixels[index]

        c_bg   = palettes[v_bg.p][v_bg.p]
        c_fg   = palettes[v_fg.p][v_fg.p]

        r = v_fg.i

        assert_in_epsilon (c_bg.r * v_bg.i) * (1 - r) + c_fg.r * r, pixel.r
        assert_in_epsilon (c_bg.g * v_bg.i) * (1 - r) + c_fg.g * r, pixel.g
        assert_in_epsilon (c_bg.b * v_bg.i) * (1 - r) + c_fg.b * r, pixel.b
      end
    end

    it 'raises an error if the given grid does not share the same context' do
      other_context     = context_klass.new rows, columns
      other_pixel_cloud = Vissen::Output::PixelCloud.new other_context

      assert_raises(TypeError) { stack.render other_pixel_cloud }
    end
  end
end
