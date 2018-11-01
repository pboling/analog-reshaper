require 'spec_helper'

RSpec.describe Scale::Destination::Range do
  describe '#initialize' do
    subject { described_class.new([]) }
    it 'does not raise' do
      block_is_expected.to_not raise_error
    end
  end
  describe '#preceding_calculable' do
    let(:range) { 0..10 }
    let(:instance) { described_class.new(range) }
    subject { instance.preceding_calculable? }
    context 'integer range' do
      it 'is true' do
        is_expected.to eq(true)
      end
    end
    context 'float range' do
      let(:range) { 0.1..0.9 }
      it 'is true' do
        is_expected.to eq(false)
      end
    end
  end
  describe '#scale' do
    let(:range) { 0..10 }
    let(:input) { 600 }
    let(:source) { Scale::Source.new(0..1000) }
    let(:instance) { described_class.new(range) }
    subject { instance.scale(input, source) }
    it 'does not raise' do
      block_is_expected.to_not raise_error
    end
    it 'returns value' do
      is_expected.to eq(5)
    end
  end
  describe '#index' do
    let(:range) { 0..10 }
    let(:input) { 600 }
    let(:source) { Scale::Source.new(0..1000) }
    let(:instance) { described_class.new(range) }
    before { instance.scale(input, source) }
    subject { instance.index }
    it 'is set' do
      is_expected.to eq(5)
    end
  end
  describe '#preceding' do
    let(:range) { 0..10 }
    let(:input) { 600 }
    let(:source) { Scale::Source.new(0..1000) }
    let(:instance) { described_class.new(range) }
    before { instance.scale(input, source) }
    subject { instance.preceding }
    it 'is set' do
      is_expected.to eq([0, 1, 2, 3, 4])
    end
  end
end
