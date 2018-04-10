# frozen_string_literal: true

require 'test_helper'

class FilterMock
  include Vissen::Output::Filter
end

class ContextMock
  include Vissen::Output::Context
end

describe Vissen::Output::Filter do
  subject { FilterMock }

  let(:context)     { ContextMock.new 2, 3 }
  let(:filter)      { subject.new context }

  describe '.new' do
    it 'accepts a context' do
      assert_equal context, filter.context
    end
  end

  describe '#apply' do
    it 'raises an exception if not implemented' do
      assert_raises(NotImplementedError) { filter.apply nil }
    end
  end
end
