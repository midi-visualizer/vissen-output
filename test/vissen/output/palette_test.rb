# frozen_string_literal: true

require 'test_helper'

describe Vissen::Output::Palette do
  subject { Vissen::Output::Palette }

  let(:colors) do
    [
      Vissen::Output::Color.new(1.0, 0, 0),
      Vissen::Output::Color.new(0, 1.0, 0),
      Vissen::Output::Color.new(0, 0, 1.0)
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

    it 'produces a frozen palette' do
      assert palette.frozen?
    end

    it 'accepts a label' do
      palette = subject.new(*colors, label: 'rainbow')
      assert_equal 'rainbow', palette.label
    end
  end

  describe '#[]' do
    it 'mixes the colors' do
      ab = colors[0].mix_with(colors[1], 0.50)
      bc = colors[1].mix_with(colors[2], 0.50)

      assert_color_equal(ab, palette[0.25])
      assert_color_equal(bc, palette[0.75])
    end

    it 'returns the nearest color down when discrete' do
      palette = subject.new(*colors, steps: 5)

      ab = colors[0].mix_with(colors[1], 0.50)
      bc = colors[1].mix_with(colors[2], 0.50)

      assert_color_equal(ab,        palette[0.30])
      assert_color_equal(colors[1], palette[0.70])
      assert_color_equal(bc,        palette[0.80])
    end
  end

  describe '#inspect' do
    it 'returns a string representation of the palette' do
      assert_equal '#FF0000 -> #00FF00 -> #0000FF',
                   palette.inspect
    end

    it 'includes the palette label' do
      palette = subject.new(*colors[0..1], label: 'rainbow')
      assert_equal '#FF0000 -> #00FF00 (rainbow)',
                   palette.inspect
    end
  end
end
