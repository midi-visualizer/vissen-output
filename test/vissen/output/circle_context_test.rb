# frozen_string_literal: true

require 'test_helper'

describe Vissen::Output::CircleContext do
  subject { Vissen::Output::CircleContext }

  let(:radius)         { rand(0.1..1.0) }
  let(:point_count)    { 4 }
  let(:circle_context) { subject.new radius, point_count }

  describe '.new' do
    it 'accepts a radius' do
      points = circle_context.points

      assert_in_delta radius,  points[0].x
      assert_in_delta 0,       points[0].y

      assert_in_delta 0,       points[1].x
      assert_in_delta radius,  points[1].y

      assert_in_delta(-radius, points[2].x)
      assert_in_delta 0,       points[2].y

      assert_in_delta 0,       points[3].x
      assert_in_delta(-radius, points[3].y)
    end

    it 'accepts a point_count' do
      assert_equal point_count, circle_context.point_count
    end

    it 'accepts an optional angle offset' do
      offset = rand(0...(2 * Math::PI))
      circle_context = subject.new radius, point_count, offset: offset
      points = circle_context.points

      assert_in_delta radius * Math.cos(offset), points[0].x
      assert_in_delta radius * Math.sin(offset), points[0].y
    end
  end
end
