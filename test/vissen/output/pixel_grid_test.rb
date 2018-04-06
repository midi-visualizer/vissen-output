require 'test_helper'

describe Vissen::Output::PixelGrid do
  subject { Vissen::Output::PixelGrid }

  let(:rows)        { 2 }
  let(:columns)     { 3 }

  let(:pixel_grid) { subject.new rows, columns }

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
      pixel = pixel_grid[rand(rows * columns)]
      
      assert_respond_to pixel, :r
      assert_respond_to pixel, :g
      assert_respond_to pixel, :b
    end
  end
end