require 'spec_helper'

RSpec.describe Scale::Destination::Enumerable do
  describe '#initialize' do
    subject { described_class.new([]) }
    it 'does not raise' do
      block_is_expected.to_not raise_error
    end
  end
  describe '#antecedent_calculable' do
    subject { described_class.new([]).cedent_calculable? }
    it 'is set' do
      is_expected.to eq(false)
    end
  end
  describe '#scale' do
    let(:enum) { [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10] }
    let(:input) { 600 }
    let(:source) { Scale::Source.new(0..1000) }
    let(:instance) { described_class.new(enum) }
    subject { instance.scale(input, source) }
    it 'does not raise' do
      block_is_expected.to_not raise_error
    end
    it 'returns value' do
      is_expected.to eq(5)
    end
  end
  describe '#index' do
    let(:enum) { [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10] }
    let(:input) { 600 }
    let(:source) { Scale::Source.new(0..1000) }
    let(:instance) { described_class.new(enum) }
    before { instance.scale(input, source) }
    subject { instance.index }
    it 'is set' do
      is_expected.to eq(5)
    end
  end
  describe '#antecedent' do
    let(:enum) { [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10] }
    let(:input) { 600 }
    let(:source) { Scale::Source.new(0..1000) }
    let(:instance) { described_class.new(enum) }
    before { instance.scale(input, source) }
    subject { instance.antecedent }
    it 'is set' do
      is_expected.to eq([0, 1, 2, 3, 4])
    end
  end
  describe '#succedent' do
    let(:enum) { [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10] }
    let(:input) { 600 }
    let(:source) { Scale::Source.new(0..1000) }
    let(:instance) { described_class.new(enum) }
    before { instance.scale(input, source) }
    subject { instance.succedent }
    it 'is set' do
      is_expected.to eq([6, 7, 8, 9, 10])
    end
  end
end
