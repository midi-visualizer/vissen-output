# frozen_string_literal: true

require 'test_helper'

describe Vissen::Output::PixelCloud do
  subject { Vissen::Output::PixelCloud }

  let(:rows)         { 6 }
  let(:columns)      { 8 }
  let(:grid_context) { Vissen::Output::Context::Grid.new rows, columns }

  let(:pixel_cloud) { subject.new grid_context }

  describe '#copy!' do
    it 'copies the pixels from another pixel_cloud' do
      pixel_cloud.pixels.each do |pixel|
        pixel.r = rand
        pixel.g = rand
        pixel.b = rand
      end

      new_pixel_cloud = subject.new grid_context

      new_pixel_cloud.copy! pixel_cloud

      new_pixel_cloud.each.with_index do |pixel, index|
        assert_equal pixel_cloud.pixels[index], pixel
      end
    end
  end

  describe '#clear!' do
    it 'clear all the pixels' do
      pixel_cloud.pixels.each do |pixel|
        pixel.r = rand
        pixel.g = rand
        pixel.b = rand
      end

      pixel_cloud.clear!

      pixel_cloud.pixels.each do |pixel|
        assert_equal 0, pixel.r
        assert_equal 0, pixel.g
        assert_equal 0, pixel.b
      end
    end
  end

  describe '#[]' do
    it 'returns a valid pixel' do
      pixel = pixel_cloud[rand(rows), rand(columns)]

      assert_respond_to pixel, :r
      assert_respond_to pixel, :g
      assert_respond_to pixel, :b
    end
  end
end
