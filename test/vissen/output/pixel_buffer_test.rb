# frozen_string_literal: true

require 'test_helper'

describe Vissen::Output::PixelBuffer do
  subject { Vissen::Output::PixelBuffer }

  let(:rows)          { 6 }
  let(:columns)       { 8 }
  let(:context_klass) { Vissen::Output::Context::Grid }
  let(:grid_context)  { context_klass.new rows, columns }
  let(:filter_klass)  { Vissen::Output::Filter::Gamma }
  let(:filter)        { filter_klass.new grid_context }
  let(:pixel_buffer)  { subject.new grid_context }

  describe '.new' do
    it 'accepts an optional array of fitlers' do
      filters = [filter]
      assert_silent { subject.new grid_context, filters }
    end

    it 'raises an error if any of the filters does not share context' do
      other_context = context_klass.new 1, 2
      other_filter  = filter_klass.new other_context
      filters = [filter, other_filter]

      assert_raises Vissen::Output::ContextError do
        subject.new grid_context, filters
      end
    end
  end

  describe '#copy!' do
    it 'copies the pixels from another pixel_buffer' do
      pixel_buffer.pixels.each do |pixel|
        pixel.r = rand
        pixel.g = rand
        pixel.b = rand
      end

      new_pixel_buffer = subject.new grid_context

      new_pixel_buffer.copy! pixel_buffer

      new_pixel_buffer.each.with_index do |pixel, index|
        assert_equal pixel_buffer.pixels[index], pixel
      end
    end
  end

  describe '#clear!' do
    it 'clear all the pixels' do
      pixel_buffer.pixels.each do |pixel|
        pixel.r = rand
        pixel.g = rand
        pixel.b = rand
      end

      pixel_buffer.clear!

      pixel_buffer.pixels.each do |pixel|
        assert_equal 0, pixel.r
        assert_equal 0, pixel.g
        assert_equal 0, pixel.b
      end
    end
  end

  describe '#finalize!' do
    it 'applies the output filters' do
      pixel_buffer = subject.new grid_context, [filter]

      r = rand
      g = rand
      b = rand

      pixel_buffer.pixels.each do |pixel|
        pixel.r = r
        pixel.g = g
        pixel.b = b
      end

      r_gamma = r**filter.value
      g_gamma = g**filter.value
      b_gamma = b**filter.value

      pixel_buffer.finalize!

      pixel_buffer.pixels.each do |pixel|
        assert_in_epsilon r_gamma, pixel.r
        assert_in_epsilon g_gamma, pixel.g
        assert_in_epsilon b_gamma, pixel.b
      end
    end
  end

  describe '#[]' do
    it 'returns a valid pixel' do
      pixel = pixel_buffer[rand(rows), rand(columns)]

      assert_respond_to pixel, :r
      assert_respond_to pixel, :g
      assert_respond_to pixel, :b
    end
  end
end
