# frozen_string_literal: true

RSpec.describe Analog::Reshaper::EdgeFinder do
  describe '.cache_store' do
    subject { described_class.cache_store }
    it 'is set' do
      is_expected.to be_a(Hash)
    end
    context ':[]' do
      subject { described_class.cache_store[1] }
      it 'does not raise' do
        block_is_expected.to_not raise_error
      end
    end
  end
  let(:power) { 2 }
  let(:instance) { described_class.new(power: power) }
  describe '#initialize' do
    subject { instance }
    it 'does not raise' do
      block_is_expected.to_not raise_error
    end
    context 'units_per' do
      subject { instance.units_per }
      it 'is set' do
        is_expected.to eq(Rational(694315685690193, 281474976710656))
      end
    end
    context 'base_units' do
      subject { instance.base_units }
      it 'is set' do
        is_expected.to eq(4.933409667914596)
      end
    end
  end
end
