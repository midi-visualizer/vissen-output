# frozen_string_literal: true

require 'test_helper'

describe Vissen::Output::Context::Cloud do
  subject { Vissen::Output::Context::Cloud }

  let(:point_count)   { 4 }
  let(:points)        { Array.new(point_count) { [rand, rand] } }
  let(:cloud_context) { subject.new points }

  describe '#point_count' do
    it 'returns the number of points in the cloud_context' do
      assert_equal point_count, cloud_context.point_count
    end
  end

  describe '.new' do
    it 'accepts and array of point coordinates' do
      points.each_with_index do |(x, y), index|
        point = cloud_context.points[index]
        assert_equal x, point.x
        assert_equal y, point.y
      end
    end

    it 'accepts an optional width and height' do
      cloud_context =
        subject.new(points, width: 10, height: 5)

      assert_equal 1.0, cloud_context.width
      assert_equal 0.5, cloud_context.height
    end

    it 'scales the coordinates to fit the adjusted width' do
      cloud_context =
        subject.new(points, width: 2, height: 1)

      points.each_with_index do |(x, y), index|
        point = cloud_context.points[index]

        assert_equal (x / 2), point.x
        assert_equal (y / 2), point.y
      end
    end
  end

  describe '.scatter' do
    it 'places points inside the context' do
      context = subject.scatter(10, width: 10, height: 5)
      context.each_position do |_, x, y|
        assert_operator x, :>=, 0.0
        assert_operator y, :>=, 0.0
        assert_operator x, :<=, 1.0
        assert_operator y, :<=, 0.5
      end
    end

    it 'keeps the distance between points' do
      min_distance = Math.sqrt(1.0 / (2 * 10))
      context = subject.scatter(10, distance: min_distance)
      context.points.permutation(2) do |p1, p2|
        d = Math.sqrt((p1.x - p2.x)**2 + (p1.y - p2.y)**2)
        assert_operator d, :>=, min_distance
      end
    end
  end

  describe '#position' do
    it 'returns the position of an element index' do
      points.each_with_index do |(x, y), index|
        pos = cloud_context.position index
        assert_equal x, pos[0]
        assert_equal y, pos[1]
      end
    end
  end
end
