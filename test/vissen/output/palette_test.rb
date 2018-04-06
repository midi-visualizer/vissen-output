require 'test_helper'
require 'color'

describe Vissen::Output::Palette do
  subject { Vissen::Output::Palette }

  let(:colors) do
    [
      Color::RGB.new(0xFF, 0, 0),
      Color::RGB.new(0, 0xFF, 0),
      Color::RGB.new(0, 0, 0xFF)
    ]
  end

  let(:palette) { subject.new(*colors) }

  describe '.new' do
    it 'accepts an arbitrarily long list of colors' do
      assert_color_equal(colors[0], palette[0])
      assert_color_equal(colors[1], palette[0.5])
      assert_color_equal(colors[2], palette[1])
    end

    it 'accepts an optional number of discrete steps' do
      palette = subject.new(*colors, steps: 5)

      assert_color_equal(colors[0], palette[0])
      assert_color_equal(colors[1], palette[0.5])
      assert_color_equal(colors[2], palette[1])
    end
  end

  describe '#[]' do
    it 'mixes the colors' do
      ab = colors[0].mix_with(colors[1], 50)
      bc = colors[1].mix_with(colors[2], 50)

      assert_color_equal(ab, palette[0.25])
      assert_color_equal(bc, palette[0.75])
    end

    it 'returns the nearest color down when discrete' do
      palette = subject.new(*colors, steps: 5)

      ab = colors[0].mix_with(colors[1], 50)
      bc = colors[1].mix_with(colors[2], 50)

      assert_color_equal(ab,        palette[0.30])
      assert_color_equal(colors[1], palette[0.70])
      assert_color_equal(bc,        palette[0.80])
    end
  end
end
