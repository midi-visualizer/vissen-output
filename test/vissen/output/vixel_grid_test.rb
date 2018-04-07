require 'test_helper'

class MockVixelGridContext
  include Vissen::Output::GridContext

  attr_reader :palettes

  def initialize(rows, columns, palettes)
    super(rows, columns)
    @palettes = palettes
  end
end

describe Vissen::Output::VixelGrid do
  subject { Vissen::Output::VixelGrid }

  let(:intensity) { rand }
  let(:rows) { 6 }
  let(:columns) { 8 }
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
  let(:grid_context) { MockVixelGridContext.new rows, columns, palettes }
  let(:vixel_grid) { subject.new grid_context }

  describe '.new' do
    it 'accepts a grid context' do
      assert_equal (rows * columns), vixel_grid.vixel_count
      assert_equal 1.0, vixel_grid.intensity

      # Test the individual vixels
      count =
        vixel_grid.vixels.each.reduce(0) do |c, vixel|
          assert_equal 0.0, vixel.p
          assert_equal 0.0, vixel.i
          c + 1
        end

      assert_equal vixel_grid.vixel_count, count
    end

    it 'accepts a grid context and an initial intensity' do
      vixel_grid = subject.new grid_context, intensity: intensity
      assert_equal intensity, vixel_grid.intensity
    end
  end

  describe '#render' do
    # A pixel should be anything with red, green and blue
    # components
    let(:pixel)  { Struct.new :r, :g, :b }
    let(:buffer) { Array.new(vixel_grid.vixel_count) { pixel.new 0, 0, 0 } }

    before do
      # Randomize the vixels
      vixel_grid.each do |vixel|
        vixel.p = rand
        vixel.i = rand
      end
    end

    it 'renders the vixels to an empty buffer' do
      vixel_grid.render(buffer)

      buffer.each_with_index do |pixel, index|
        vixel = vixel_grid.vixels[index]
        color = palettes[0][vixel.p]

        assert_in_epsilon color.r * vixel.i, pixel.r
        assert_in_epsilon color.g * vixel.i, pixel.g
        assert_in_epsilon color.b * vixel.i, pixel.b
      end
    end

    it 'renders the vixels to a non-empty buffer' do
      buffer.each { |p| p.r = 0.5; p.g = 0.5; p.b = 0.5 }
      vixel_grid.render(buffer)

      buffer.each_with_index do |pixel, index|
        vixel = vixel_grid.vixels[index]
        color = palettes[0][vixel.p]

        r = vixel.i
        s = (1 - r) * 0.5

        assert_in_epsilon color.r * r + s, pixel.r
        assert_in_epsilon color.g * r + s, pixel.g
        assert_in_epsilon color.b * r + s, pixel.b
      end
    end

    it 'renders the vixels with a global intensity' do
      vixel_grid.intensity = 0.5
      vixel_grid.render(buffer)

      buffer.each_with_index do |pixel, index|
        vixel = vixel_grid.vixels[index]
        color = palettes[0][vixel.p]

        r = vixel.i * 0.5

        assert_in_epsilon color.r * r, pixel.r
        assert_in_epsilon color.g * r, pixel.g
        assert_in_epsilon color.b * r, pixel.b
      end
    end

    it 'renders from the given palette' do
      vixel_grid.palette = 1
      vixel_grid.render(buffer)

      buffer.each_with_index do |pixel, index|
        vixel = vixel_grid.vixels[index]
        color = palettes[1][vixel.p]

        r = vixel.i

        assert_in_epsilon color.r * r, pixel.r
        assert_in_epsilon color.g * r, pixel.g
        assert_in_epsilon color.b * r, pixel.b
      end
    end
  end
end
