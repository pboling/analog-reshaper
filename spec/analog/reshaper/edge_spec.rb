# frozen_string_literal: true

RSpec.describe Analog::Reshaper::Edge do
  let(:units) { 100.0 }
  let(:units_per) { 10.0 }
  let(:instance) { described_class.new(units: units, units_per: units_per) }
  describe '#initialize' do
    subject { instance }
    it 'does not raise' do
      block_is_expected.to_not raise_error
    end
    context 'units_per' do
      subject { instance.units_per }
      it 'is set' do
        is_expected.to eq(10)
      end
    end
    context 'index' do
      subject { instance.index }
      it 'is set' do
        is_expected.to eq(9)
      end
    end
    context 'remainder' do
      subject { instance.remainder }
      it 'is set' do
        is_expected.to eq(0)
      end
    end
  end
end
