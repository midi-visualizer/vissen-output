# frozen_string_literal: true

require 'test_helper'

describe Vissen::Output::Context::Circle do
  subject { Vissen::Output::Context::Circle }

  let(:radius)         { rand(0.1..0.5) }
  let(:point_count)    { 4 }
  let(:circle_context) { subject.new point_count }

  describe '.new' do
    it 'accepts a radius' do
      circle_context = subject.new point_count, radius: radius
      points = circle_context.points

      x0 = circle_context.width / 2
      y0 = circle_context.height / 2

      assert_in_delta x0 + radius, points[0].x
      assert_in_delta y0 + 0,      points[0].y

      assert_in_delta x0 + 0,      points[1].x
      assert_in_delta y0 + radius, points[1].y

      assert_in_delta(x0 - radius, points[2].x)
      assert_in_delta y0 + 0,      points[2].y

      assert_in_delta x0 + 0,      points[3].x
      assert_in_delta(y0 - radius, points[3].y)
    end

    it 'accepts a point_count' do
      assert_equal point_count, circle_context.point_count
    end

    it 'accepts an optional angle offset' do
      offset = rand(0...(2 * Math::PI))
      circle_context = subject.new point_count, offset: offset
      radius = 0.5

      x0 = circle_context.width / 2
      y0 = circle_context.height / 2

      points = circle_context.points

      assert_in_delta x0 + radius * Math.cos(offset), points[0].x
      assert_in_delta y0 + radius * Math.sin(offset), points[0].y
    end

    it 'accepts a width and a height' do
      width  = 10
      height = 5

      circle_context = subject.new point_count, width: width,
                                                height: height

      points = circle_context.points
      radius_normalized = 1.0 / width * (height.to_f / 2)

      x0 = circle_context.width / 2
      y0 = circle_context.height / 2

      assert_in_delta x0 + radius_normalized, points[0].x
      assert_in_delta y0 + 0,                 points[0].y

      assert_in_delta x0 + 0,                 points[1].x
      assert_in_delta y0 + radius_normalized, points[1].y

      assert_in_delta(x0 - radius_normalized, points[2].x)
      assert_in_delta y0 + 0,                 points[2].y

      assert_in_delta x0 + 0,                 points[3].x
      assert_in_delta(y0 - radius_normalized, points[3].y)
    end
  end
end
