# frozen_string_literal: true

require 'test_helper'

describe Vissen::Output::Vixel do
  subject { Vissen::Output::Vixel }

  let(:vixel) { subject.new rand, rand }

  describe '.new' do
    it 'accepts a palette and intensity value' do
      p = rand
      i = rand

      vixel = subject.new i, p

      assert_equal p, vixel.p
      assert_equal i, vixel.i
    end

    it 'truncates values greater than 1' do
      vixel = subject.new 1.1, 4.3

      assert_equal 1.0, vixel.p
      assert_equal 1.0, vixel.i
    end

    it 'truncates values smaller than 0' do
      vixel = subject.new(-4.2, -1.1)

      assert_equal 0.0, vixel.p
      assert_equal 0.0, vixel.i
    end
  end

  describe '#==' do
    it 'returns true when two vixels have the same values' do
      p = rand
      i = rand

      vixel = subject.new i, p
      other = subject.new i, p

      assert_operator vixel, :==, other
    end

    it 'returns false when two vixels do not have the same values' do
      vixel = subject.new 0.2, 0.4
      other = subject.new 0.3, 0.5

      refute_operator vixel, :==, other
    end

    it 'returns false for other objects' do
      refute_operator vixel, :==, Object.new
    end
  end

  describe '#inspect' do
    it 'returns a string representation of the vixel' do
      vixel = subject.new 0.6, 0.23333

      assert_equal '(0.6, 0.2)', vixel.inspect
    end
  end
end
