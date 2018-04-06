require 'test_helper'

describe Vissen::Output::VixelGrid do
  subject { Vissen::Output::VixelGrid }

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
  let(:vixel_grid) { subject.new rows, columns, layer_count, palettes }

  it 'is a grid' do
    assert_kind_of Vissen::Output::Grid, vixel_grid
  end

  describe '.new' do
    it 'raises a RangeError when layer_count <= 0' do
      assert_raises(RangeError) do
        subject.new rows, columns, 0, palettes
      end
    end

    it 'raises an ArgumentError if no palettes are given' do
      assert_raises(ArgumentError) do
        subject.new rows, columns, layer_count, []
      end
    end

    it 'raises an TypeError if the palettes do not respond to #[]' do
      assert_raises(TypeError) do
        subject.new rows, columns, layer_count, [[], Object.new]
      end
    end
  end

  describe '#[]' do
    it 'returns a vixel' do
      assert_kind_of Vissen::Output::Vixel, vixel_grid[0, 0, 0]
    end

    it 'returns the correct vixel' do
      layer  = rand layer_count
      row    = rand rows
      column = rand columns
      index  = vixel_grid.index_from row, column
      vixel  = vixel_grid.layers[layer][index]

      assert_equal vixel, vixel_grid[layer, row, column]
    end
  end

  describe '#pixel_grid' do
    it 'returns a pixel grid of the same size' do
      pixel_grid = vixel_grid.pixel_grid

      assert_kind_of Vissen::Output::PixelGrid, pixel_grid
      assert_equal vixel_grid.rows,    pixel_grid.rows
      assert_equal vixel_grid.columns, pixel_grid.columns
      assert_equal vixel_grid.width,   pixel_grid.width
      assert_equal vixel_grid.height,  pixel_grid.height
    end
  end

  describe '#render' do
    let(:pixel_grid) { vixel_grid.pixel_grid }
    let(:pixels)     { pixel_grid.pixels }

    before do
      # Randomize the vixels
      vixel_grid.layers.each do |layer|
        layer.each do |vixel|
          vixel.p = rand layer_count
          vixel.q = rand
          vixel.i = rand
        end
      end
    end

    it 'renders the vixels to a pixel grid' do
      vixel_grid.render(pixel_grid)

      pixels.each_with_index do |pixel, index|
        v_bg = vixel_grid.layers[0][index]
        v_fg = vixel_grid.layers[1][index]

        c_bg   = palettes[v_bg.p][v_bg.q]
        c_fg   = palettes[v_fg.p][v_fg.q]

        r = v_fg.i

        assert_in_epsilon (c_bg.r * v_bg.i) * (1 - r) + c_fg.r * r, pixel.r
        assert_in_epsilon (c_bg.g * v_bg.i) * (1 - r) + c_fg.g * r, pixel.g
        assert_in_epsilon (c_bg.b * v_bg.i) * (1 - r) + c_fg.b * r, pixel.b
      end
    end

    it 'raises an error if the given grid is not sized right' do
      pixel_grid = Vissen::Output::PixelGrid.new rows - 1, columns
      assert_raises(TypeError) { vixel_grid.render(pixel_grid) }
    end
  end
end
