require 'test_helper'

describe Vissen::Output::Vixel do
  subject { Vissen::Output::Vixel }

  describe '.new' do
    it 'truncates values greater than 1' do
      vixel = subject.new 0, 1.1, 4.3

      assert_equal 1.0, vixel.q
      assert_equal 1.0, vixel.i
    end

    it 'truncates values smaller than 0' do
      vixel = subject.new(0, -4.2, -1.1)

      assert_equal 0.0, vixel.q
      assert_equal 0.0, vixel.i
    end
  end
  
  describe '#inspect' do
    it 'returns a string representation of the vixel' do
      vixel = subject.new 5, 0.6, 0.23333
      
      assert_equal '(5 | 0.6, 0.2)', vixel.inspect
    end
  end
end
