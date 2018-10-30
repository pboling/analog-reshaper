# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Analog::Reshaper::Graduate do
  let(:input) { 10 }
  let(:factors) { [1.5, 2.0, 2.5 ] }
  let(:factor_method) { :* }
  let(:coverage_type) { :over }
  let(:section_configs) do
    {
        26..1000 => factors,
        13..25 => factors,
        6..12  => factors,
        2..5   => factors,
        1..1   => [1],
    }
  end
  let(:shaping_arguments) do
    {
        section_configs: section_configs,
        factor_method: factor_method,
        coverage_type: coverage_type
    }
  end
  let(:shaping_configuration) { Analog::Reshaper::ShapingConfiguration.new(**shaping_arguments) }
  let(:arguments) do
    {
        input: input,
        shaping_config: shaping_configuration
    }
  end
  let(:graduate) { described_class.new(**arguments) }
  subject { graduate }
  describe '#initialize' do
    it 'does not error' do
      block_is_expected.to_not raise_error
    end
    context 'attributes' do
      context 'input_value' do
        subject { graduate.input_value }
        it 'is set' do
          is_expected.to be_a(Integer)
          is_expected.to eq(input)
        end
      end
      context 'output_value' do
        subject { graduate.output_value }
        it 'is set' do
          is_expected.to be_a(Integer)
          is_expected.to eq(8)
        end
      end
      context 'shaping_config' do
        subject { graduate.shaping_config }
        it 'is set' do
          is_expected.to be_a(Analog::Reshaper::ShapingConfiguration)
        end
      end
      context 'section' do
        subject { graduate.section }
        it 'is set' do
          is_expected.to be_a(Analog::Reshaper::SectionConfiguration)
        end
      end
      context 'maximum' do
        subject { graduate.maximum }
        it 'is set' do
          is_expected.to eq(1000)
        end
      end
      context 'factor_method' do
        subject { graduate.factor_method }
        it 'is set' do
          is_expected.to eq(:*)
        end
      end
      context 'coverage_type' do
        subject { graduate.coverage_type }
        it 'is set' do
          is_expected.to eq(:over)
        end
      end
      context 'range' do
        subject { graduate.range }
        it 'is set' do
          is_expected.to eq(6..12)
        end
      end
      context 'factors' do
        subject { graduate.factors }
        it 'is set' do
          is_expected.to eq([1.5, 2.0, 2.5])
        end
      end
      context 'cumulative' do
        subject { graduate.cumulative }
        it 'is set' do
          is_expected.to eq(56.25)
        end
      end
      context 'distance' do
        subject { graduate.distance }
        it 'is set' do
          is_expected.to eq(6)
        end
      end
      context 'first' do
        subject { graduate.first }
        it 'is set' do
          is_expected.to eq(6)
        end
      end
      context 'last' do
        subject { graduate.last }
        it 'is set' do
          is_expected.to eq(12)
        end
      end
    end
  end
  describe 'shaping' do
    {
        1 => 0,
        2 => 0,
        3 => 0,
        4 => 1,
        5 => 2,
        6 => 2,
        7 => 2,
        8 => 2,
        9 => 7,
        10 => 8,
        11 => 16,
        12 => 17,
        13 => 17,
        14 => 18,
        15 => 19,
        16 => 20,
        17 => 22,
        18 => 56,
        19 => 59,
        20 => 62,
        21 => 66,
        22 => 118,
        23 => 123,
        24 => 127,
        25 => 133,
        50 => 135,
        75 => 137,
        100 => 139,
        200 => 149,
        300 => 160,
        400 => 412,
        500 => 440,
        600 => 472,
        700 => 866,
        800 => 906,
        900 => 951,
        1000 => 1000,
    }.each do |k, v|
      context ":* #{k}" do
        let(:factor_method) { :* }
        let(:input) { k }
        subject { graduate.output_value }
        it "gives: #{v}" do
          is_expected.to eq(v)
        end
      end
    end
    {
        1 => 40,
        2 => 41,
        3 => 23,
        4 => 38,
        5 => 55,
        6 => 55,
        7 => 28,
        8 => 32,
        9 => 49,
        10 => 55,
        11 => 76,
        12 => 83,
        13 => 83,
        14 => 44,
        15 => 46,
        16 => 49,
        17 => 52,
        18 => 84,
        19 => 88,
        20 => 94,
        21 => 100,
        22 => 148,
        23 => 153,
        24 => 160,
        25 => 166,
        50 => 90,
        75 => 91,
        100 => 93,
        200 => 99,
        300 => 106,
        400 => 247,
        500 => 264,
        600 => 283,
        700 => 866,
        800 => 906,
        900 => 951,
        1000 => 1000,
    }.each do |k, v|
      context ":+ #{k}" do
        let(:factor_method) { :+ }
        let(:input) { k }
        subject { graduate.output_value }
        it "gives: #{v}" do
          is_expected.to eq(v)
        end
      end
    end
  end
end
