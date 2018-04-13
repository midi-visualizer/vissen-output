# frozen_string_literal: true

require 'test_helper'

describe Vissen::Output::VixelCloud do
  subject { Vissen::Output::VixelCloud }

  let(:intensity) { rand }
  let(:rows) { 6 }
  let(:columns) { 8 }
  let(:colors) do
    [
      Vissen::Output::Color.new(1, 0, 0),
      Vissen::Output::Color.new(0, 1, 0),
      Vissen::Output::Color.new(0, 0, 1)
    ]
  end
  let(:palettes) do
    [
      Vissen::Output::Palette.new(*colors),
      Vissen::Output::Palette.new(*colors.reverse)
    ]
  end
  let(:context_klass) { Vissen::Output::Context::Grid }
  let(:grid_context) { context_klass.new rows, columns, palettes: palettes }
  let(:vixel_cloud)  { subject.new grid_context }

  describe '.new' do
    it 'accepts a grid context' do
      assert_equal (rows * columns), vixel_cloud.vixel_count
      assert_equal 1.0, vixel_cloud.intensity

      # Test the individual vixels
      count =
        vixel_cloud.vixels.each.reduce(0) do |c, vixel|
          assert_equal 0.0, vixel.p
          assert_equal 0.0, vixel.i
          c + 1
        end

      assert_equal vixel_cloud.vixel_count, count
    end

    it 'accepts a grid context and an initial intensity' do
      vixel_cloud = subject.new grid_context, intensity: intensity
      assert_equal intensity, vixel_cloud.intensity
    end
  end

  describe '#render' do
    # A pixel should be anything with red, green and blue
    # components
    let(:pixel)  { Vissen::Output::Color }
    let(:buffer) { Array.new(vixel_cloud.vixel_count) { pixel.new 0, 0, 0 } }

    before do
      # Randomize the vixels
      vixel_cloud.each do |vixel|
        vixel.p = rand
        vixel.i = rand
      end
    end

    it 'renders the vixels to an empty buffer' do
      vixel_cloud.render(buffer)

      buffer.each_with_index do |pixel, index|
        vixel = vixel_cloud.vixels[index]
        color = palettes[0][vixel.p]

        assert_in_epsilon color.r * vixel.i, pixel.r
        assert_in_epsilon color.g * vixel.i, pixel.g
        assert_in_epsilon color.b * vixel.i, pixel.b
      end
    end

    it 'renders the vixels to a non-empty buffer' do
      buffer.each do |pixel|
        pixel.r = 0.5
        pixel.g = 0.5
        pixel.b = 0.5
      end

      vixel_cloud.render(buffer)

      buffer.each_with_index do |pixel, index|
        vixel = vixel_cloud.vixels[index]
        color = palettes[0][vixel.p]

        r = vixel.i
        s = (1 - r) * 0.5

        assert_in_epsilon color.r * r + s, pixel.r
        assert_in_epsilon color.g * r + s, pixel.g
        assert_in_epsilon color.b * r + s, pixel.b
      end
    end

    it 'renders the vixels with a global intensity' do
      vixel_cloud.intensity = 0.5
      vixel_cloud.render(buffer)

      buffer.each_with_index do |pixel, index|
        vixel = vixel_cloud.vixels[index]
        color = palettes[0][vixel.p]

        r = vixel.i * 0.5

        assert_in_epsilon color.r * r, pixel.r
        assert_in_epsilon color.g * r, pixel.g
        assert_in_epsilon color.b * r, pixel.b
      end
    end

    it 'renders from the given palette' do
      vixel_cloud.palette = 1
      vixel_cloud.render(buffer)

      buffer.each_with_index do |pixel, index|
        vixel = vixel_cloud.vixels[index]
        color = palettes[1][vixel.p]

        r = vixel.i

        assert_in_epsilon color.r * r, pixel.r
        assert_in_epsilon color.g * r, pixel.g
        assert_in_epsilon color.b * r, pixel.b
      end
    end
  end
end
