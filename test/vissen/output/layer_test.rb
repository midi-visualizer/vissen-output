require 'test_helper'

GridMock = Struct.new :vixel_count, :palettes do
  def alloc_points(klass)
    Array.new(vixel_count) { klass.new }
  end
end

describe Vissen::Output::Layer do
  subject { Vissen::Output::Layer }

  let(:intensity)   { rand }
  let(:vixel_count) { 8 }
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
  let(:grid)       { GridMock.new vixel_count, palettes }
  let(:layer)       { subject.new grid }

  describe '.new' do
    it 'accepts a grid' do
      assert_equal vixel_count, layer.vixel_count
      assert_equal 1.0, layer.intensity

      # Test the individual vixels
      count =
        layer.vixels.each.reduce(0) do |c, vixel|
          assert_equal 0,   vixel.p
          assert_equal 0.0, vixel.q
          assert_equal 0.0, vixel.i
          c + 1
        end

      assert_equal vixel_count, count
    end

    it 'accepts a grid and an initial intensity' do
      layer = subject.new grid, intensity: intensity
      assert_equal intensity, layer.intensity
    end
  end

  describe '#render' do
    # A pixel should be anything with red, green and blue
    # components
    let(:pixel)  { Struct.new :r, :g, :b }
    let(:buffer) { Array.new(layer.vixel_count) { pixel.new 0, 0, 0 } }

    before do
      # Randomize the vixels
      layer.each do |vixel|
        vixel.p = rand 0..1
        vixel.q = rand
        vixel.i = rand
      end
    end

    it 'renders the vixels to an empty buffer' do
      layer.render(buffer)

      buffer.each_with_index do |pixel, index|
        vixel   = layer[index]
        palette = palettes[vixel.p]
        color   = palette[vixel.q]

        assert_in_epsilon color.r * vixel.i, pixel.r
        assert_in_epsilon color.g * vixel.i, pixel.g
        assert_in_epsilon color.b * vixel.i, pixel.b
      end
    end

    it 'renders the vixels to a non-empty buffer' do
      buffer.each { |p| p.r = 0.5; p.g = 0.5; p.b = 0.5 }
      layer.render(buffer)

      buffer.each_with_index do |pixel, index|
        vixel   = layer[index]
        palette = palettes[vixel.p]
        color   = palette[vixel.q]

        r = vixel.i
        s = (1 - r) * 0.5

        assert_in_epsilon color.r * r + s, pixel.r
        assert_in_epsilon color.g * r + s, pixel.g
        assert_in_epsilon color.b * r + s, pixel.b
      end
    end

    it 'renders the vixels with a global intensity' do
      layer.intensity = 0.5
      layer.render(buffer)

      buffer.each_with_index do |pixel, index|
        vixel   = layer[index]
        palette = palettes[vixel.p]
        color   = palette[vixel.q]

        r = vixel.i * 0.5

        assert_in_epsilon color.r * r, pixel.r
        assert_in_epsilon color.g * r, pixel.g
        assert_in_epsilon color.b * r, pixel.b
      end
    end
  end
end
