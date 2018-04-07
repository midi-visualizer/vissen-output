require 'test_helper'

class MockPixelGridContext
  include Vissen::Output::GridContext
end

describe Vissen::Output::PixelGrid do
  subject { Vissen::Output::PixelGrid }

  let(:rows)         { 6 }
  let(:columns)      { 8 }
  let(:grid_context) { MockPixelGridContext.new rows, columns }

  let(:pixel_grid)   { subject.new grid_context }

  it 'is a grid' do
    assert_kind_of Vissen::Output::Grid, pixel_grid
  end

  describe '#clear!' do
    it 'clear all the pixels' do
      pixel_grid.pixels.each do |pixel|
        pixel.r = rand
        pixel.g = rand
        pixel.b = rand
      end

      pixel_grid.clear!

      pixel_grid.pixels.each do |pixel|
        assert_equal 0, pixel.r
        assert_equal 0, pixel.g
        assert_equal 0, pixel.b
      end
    end
  end

  describe '#[]' do
    it 'returns a valid pixel' do
      pixel = pixel_grid[rand(rows), rand(columns)]

      assert_respond_to pixel, :r
      assert_respond_to pixel, :g
      assert_respond_to pixel, :b
    end
  end
end
