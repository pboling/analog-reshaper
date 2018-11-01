# frozen_string_literal: true

RSpec.describe Analog::Reshaper::SectionConfiguration do
  let(:range) { 2..10 }
  let(:factors) { [1.5, 2.0, 2.5] }
  let(:cumulative) { 100 }
  let(:factor_method) { :* }
  let(:coverage_type) { :over }
  let(:arguments) do
    [
      range, factors, cumulative, factor_method, coverage_type
    ]
  end
  let(:section) { described_class.new(*arguments) }
  describe '#initialize' do
    subject { section }
    it 'does not error' do
      block_is_expected.to_not raise_error
    end
    context 'attributes' do
      context 'range' do
        subject { section.range }
        it 'is set' do
          is_expected.to be_a(Range)
          is_expected.to eq(range)
        end
      end
      context 'factors' do
        subject { section.factors }
        it 'is set' do
          is_expected.to be_a(Array)
          is_expected.to eq(factors)
        end
      end
      context 'cumulative' do
        subject { section.cumulative }
        it 'is set' do
          is_expected.to be_a(Integer)
          is_expected.to eq(cumulative)
        end
      end
      context 'factor_method' do
        subject { section.factor_method }
        it 'is set' do
          is_expected.to be_a(Symbol)
          is_expected.to eq(:*)
        end
      end
      context 'coverage_type' do
        subject { section.coverage_type }
        it 'is set' do
          is_expected.to be_a(Symbol)
          is_expected.to eq(:over)
        end
      end
    end
  end
  describe 'first' do
    let(:range) { 30..50 }
    subject { section.first }
    it 'is an integer' do
      is_expected.to be_a(Integer)
      is_expected.to eq(30)
    end
  end
  describe 'last' do
    let(:range) { 100..200 }
    subject { section.last }
    it 'is an integer' do
      is_expected.to be_a(Integer)
      is_expected.to eq(200)
    end
  end
  describe 'distance' do
    let(:range) { 10..40 }
    subject { section.distance }
    it 'is an integer' do
      is_expected.to be_a(Integer)
      is_expected.to eq(30)
    end
  end
  describe 'to_s' do
    let(:range) { 1..3 }
    subject { section.to_s }
    it 'is a string' do
      is_expected.to be_a(String)
      is_expected.to eq('1..3')
    end
  end
  describe 'inspect' do
    let(:range) { 1..2 }
    let(:factors) { [3, 4] }
    subject { section.inspect }
    it 'is a float' do
      is_expected.to be_a(String)
      is_expected.to match(/<#Analog::Reshaper::SectionConfiguration \d+ 1\.\.2 => \[3, 4\] \(\* over\)>/)
    end
  end
end
