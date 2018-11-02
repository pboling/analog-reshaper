# frozen_string_literal: true

RSpec.describe Analog::Reshaper::Graduate do
  let(:input) { 10 }
  let(:factors) { [1.5, 2.0, 2.5 ] }
  let(:factor_method) { :* }
  let(:coverage_type) { :over }
  let(:cumulative_direction) { :succedent }
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
        coverage_type: coverage_type,
        cumulative_direction: cumulative_direction
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
      context '#input_value' do
        subject { graduate.input_value }
        it 'is set' do
          is_expected.to be_a(Numeric)
          is_expected.to eq(input)
        end
      end
      context '#output_value' do
        subject { graduate.output_value }
        context 'succedent' do
          let(:cumulative_direction) { :succedent }
          it 'is set' do
            is_expected.to be_a(Numeric)
            is_expected.to eq(101.0)
          end
        end
        context 'antecedent' do
          let(:cumulative_direction) { :antecedent }
          it 'is set' do
            is_expected.to be_a(Numeric)
            is_expected.to eq(578.5)
          end
        end
      end
      context '#shaping_config' do
        subject { graduate.shaping_config }
        it 'is set' do
          is_expected.to be_a(Analog::Reshaper::ShapingConfiguration)
        end
      end
      context '#section' do
        subject { graduate.section }
        it 'is set' do
          is_expected.to be_a(Analog::Reshaper::SectionConfiguration)
        end
      end
      context '#value_source' do
        subject { graduate.value_source }
        it 'is set' do
          is_expected.to be_a(Scale::Source::Range)
        end
        context '#denominator' do
          subject { graduate.value_source.denominator }
          it 'is set' do
            is_expected.to eq(6.0)
          end
        end
      end
      context '#shape_destination' do
        subject { graduate.shape_destination }
        it 'is set' do
          is_expected.to be_a(Scale::Destination::Enumerable)
        end
        context '#cedent_calculable?' do
          subject { graduate.shape_destination.cedent_calculable? }
          it 'is set' do
            is_expected.to eq(true)
          end
        end
      end
      context '#maximum' do
        subject { graduate.maximum }
        it 'is set' do
          is_expected.to eq(1000)
        end
      end
      context '#factor_method' do
        subject { graduate.factor_method }
        it 'is set' do
          is_expected.to eq(:*)
        end
      end
      context '#coverage_type' do
        subject { graduate.coverage_type }
        it 'is set' do
          is_expected.to eq(:over)
        end
      end
      context '#range' do
        subject { graduate.range }
        it 'is set' do
          is_expected.to eq(6..12)
        end
      end
      context '#factors' do
        subject { graduate.factors }
        it 'is set' do
          is_expected.to eq([1.5, 2.0, 2.5])
        end
      end
      context '#cumulative' do
        context 'succedent' do
          let(:cumulative_direction) { :succedent }
          subject { graduate.cumulative }
          it 'is set' do
            is_expected.to eq(7.5)
          end
        end
        context 'antecedent' do
          let(:cumulative_direction) { :antecedent }
          subject { graduate.cumulative }
          it 'is set' do
            is_expected.to eq(56.25)
          end
        end
      end
      context '#distance' do
        subject { graduate.distance }
        it 'is set' do
          is_expected.to eq(6)
        end
      end
      context '#first' do
        subject { graduate.first }
        it 'is set' do
          is_expected.to eq(6)
        end
      end
      context '#last' do
        subject { graduate.last }
        it 'is set' do
          is_expected.to eq(12)
        end
      end
      context '#low_end' do
        subject { graduate.low_end }
        it 'is set' do
          is_expected.to eq(6)
        end
      end
      context '#high_end' do
        subject { graduate.high_end }
        it 'is set' do
          is_expected.to eq(12)
        end
      end
      context '#portion_of_section' do
        subject { graduate.portion_of_section }
        it 'does not error' do
          block_is_expected.to_not raise_error
        end
        it 'is ratio' do
          is_expected.to eq(Rational(17, 50))
        end
      end
      context '#applicable_factor' do
        subject { graduate.applicable_factor }
        it 'does not error' do
          block_is_expected.to_not raise_error
        end
        it 'is middle factor' do
          is_expected.to eq(2.0)
        end
      end
    end
  end

  context 'input outside high end of factor key range' do
    let(:factor_method) { :* }
    let(:coverage_type) { :over }
    let(:cumulative_direction) { :succedent }
    let(:section_configs) do
      {
          1..100 => [1.0],
      }
    end
    let(:input) { 101 }
    subject { graduate.output_value }
    it "does not raise error" do
      block_is_expected.to_not raise_error
    end
    it "returns shape maximum" do
      is_expected.to eq(100)
    end
  end

  context 'input outside low end of factor key range' do
    let(:factor_method) { :* }
    let(:coverage_type) { :over }
    let(:cumulative_direction) { :succedent }
    let(:section_configs) do
      {
          10..100 => [1.0],
      }
    end
    let(:input) { 9 }
    subject { graduate.output_value }
    it "does not raise error" do
      block_is_expected.to_not raise_error
    end
    it "returns shape minimum" do
      is_expected.to eq(10)
    end
  end

  context 'input found missing middle section' do
    let(:factor_method) { :* }
    let(:coverage_type) { :over }
    let(:cumulative_direction) { :succedent }
    let(:section_configs) do
      {
          1..8 => [1.2],
          10..100 => [1.2],
      }
    end
    let(:input) { 9 }
    subject { graduate.output_value }
    it "does not raise error" do
      block_is_expected.to_not raise_error
    end
    it "returns shape minimum" do
      is_expected.to eq(9)
    end
  end

  context 'factor :*, coverage :over, cumulative_direction :succedent, 1..1_000, top reduction, 3 factors' do
    {
        1 => 2,
        # 10 => 20,
        # 50 => 100,
        # 100 => 200
    }.each do |k, v|
      context ":* #{k}" do
        let(:factor_method) { :* }
        let(:coverage_type) { :over }
        let(:cumulative_direction) { :succedent }
        let(:section_configs) do
          {
              1..100 => [0, 1.0, 2.0, 1.0],
          }
        end
        let(:input) { k }
        subject { graduate.output_value }
        it "gives: #{v}" do
          is_expected.to eq(v)
        end
      end
    end
  end

  # context 'factor :*, coverage :over, cumulative_direction :succedent, 1..1_000, top reduction, 3 factors' do
  #   {
  #       # 1 => 0,
  #       # 2 => 0,
  #       # 3 => 0,
  #       # 4 => 1,
  #       # 5 => 2,
  #       # 6 => 2,
  #       # 7 => 2,
  #       # 8 => 2,
  #       # 9 => 7,
  #       # 10 => 8,
  #       # 11 => 16,
  #       # 12 => 17,
  #       # 13 => 17,
  #       # 14 => 18,
  #       # 15 => 19,
  #       # 16 => 20,
  #       # 17 => 22,
  #       # 18 => 56,
  #       # 19 => 59,
  #       # 20 => 62,
  #       # 21 => 66,
  #       # 22 => 118,
  #       # 23 => 123,
  #       # 24 => 127,
  #       # 25 => 133,
  #       50 => 135,
  #       # 75 => 137,
  #       # 100 => 139,
  #       # 200 => 149,
  #       # 300 => 160,
  #       # 400 => 412,
  #       # 500 => 440,
  #       # 600 => 472,
  #       # 700 => 866,
  #       # 800 => 906,
  #       # 900 => 951,
  #       # 1000 => 133,
  #   }.each do |k, v|
  #     context ":* #{k}" do
  #       let(:factor_method) { :* }
  #       let(:coverage_type) { :over }
  #       let(:cumulative_direction) { :succedent }
  #       let(:section_configs) do
  #         {
  #             26..1000 => factors,
  #             13..25 => factors,
  #             6..12  => factors,
  #             2..5   => factors,
  #             1..1   => [1],
  #         }
  #       end
  #       let(:input) { k }
  #       subject { graduate.output_value }
  #       it "gives: #{v}" do
  #         is_expected.to eq(v)
  #       end
  #     end
  #   end
  # end

  # context 'factor :*, coverage :over, cumulative_direction :succedent, 1..100_000, top reduction, 11 factors' do
  #   {
  #       1 => 515,
  #       # 2 => 0,
  #       # 3 => 0,
  #       # 4 => 1,
  #       # 5 => 2,
  #       # 6 => 2,
  #       # 7 => 2,
  #       # 8 => 2,
  #       # 9 => 7,
  #       # 10 => 8,
  #       # 11 => 16,
  #       # 12 => 17,
  #       # 13 => 17,
  #       # 14 => 18,
  #       # 15 => 19,
  #       # 16 => 20,
  #       # 17 => 22,
  #       # 18 => 56,
  #       # 19 => 59,
  #       # 20 => 62,
  #       # 21 => 66,
  #       # 22 => 118,
  #       # 23 => 123,
  #       # 24 => 127,
  #       # 25 => 133,
  #       # 50 => 135,
  #       # 75 => 137,
  #       # 100 => 139,
  #       # 200 => 149,
  #       # 300 => 160,
  #       # 400 => 412,
  #       # 500 => 440,
  #       # 600 => 472,
  #       # 700 => 866,
  #       # 800 => 906,
  #       # 900 => 951,
  #       1000 => 944,
  #   }.each do |k, v|
  #     context ":* #{k}" do
  #       let(:factors) { [1.05, 1.06, 1.07, 1.08, 1.09, 1.1, 1.11, 1.12, 1.13, 1.14, 1.15 ] }
  #       let(:factor_method) { :* }
  #       let(:coverage_type) { :over }
  #       let(:cumulative_direction) { :succedent }
  #       let(:section_configs) do
  #         {
  #             26_000..100_000 => factors,
  #             13_000..25_999 => factors,
  #             6_000..12_999  => factors,
  #             2_000..5_999   => factors,
  #             1..1_999   => factors,
  #         }
  #       end
  #       let(:input) { k }
  #       subject { graduate.output_value }
  #       it "gives: #{v}" do
  #         is_expected.to eq(v)
  #       end
  #     end
  #   end
  # end
  #
  # context 'factor :*, coverage :over, cumulative_direction :succedent, 1..100_000, top reduction, 19 factors' do
  #   {
  #       1 => 1913875,
  #       # 2 => 41,
  #       # 3 => 23,
  #       # 4 => 38,
  #       # 5 => 55,
  #       # 6 => 55,
  #       # 7 => 28,
  #       # 8 => 32,
  #       # 9 => 49,
  #       # 10 => 55,
  #       # 11 => 76,
  #       # 12 => 83,
  #       # 13 => 83,
  #       # 14 => 44,
  #       # 15 => 46,
  #       # 16 => 49,
  #       # 17 => 52,
  #       # 18 => 84,
  #       # 19 => 88,
  #       # 20 => 94,
  #       # 21 => 100,
  #       # 22 => 148,
  #       # 23 => 153,
  #       # 24 => 160,
  #       # 25 => 166,
  #       # 50 => 90,
  #       # 75 => 91,
  #       # 100 => 93,
  #       # 200 => 99,
  #       # 300 => 106,
  #       # 400 => 247,
  #       # 500 => 264,
  #       # 600 => 283,
  #       # 700 => 866,
  #       # 800 => 906,
  #       # 900 => 951,
  #       1000 => 41882,
  #   }.each do |k, v|
  #     context ":+ #{k}" do
  #       let(:factors) { [0.01, 0.015, 0.02, 0.025, 0.03, 0.035, 0.04, 0.045, 0.05, 0.055, 0.06, 0.065, 0.07, 0.075, 0.08, 0.085, 0.09, 0.095, 0.1 ] }
  #       let(:factor_method) { :+ }
  #       let(:coverage_type) { :over }
  #       let(:cumulative_direction) { :succedent }
  #       let(:section_configs) do
  #         {
  #             26_000..100_000 => factors,
  #             13_000..25_999 => factors,
  #             6_000..12_999  => factors,
  #             2_000..5_999   => factors,
  #             1..1_999   => factors,
  #         }
  #       end
  #       let(:input) { k }
  #       subject { graduate.output_value }
  #       it "gives: #{v}" do
  #         is_expected.to eq(v)
  #       end
  #     end
  #   end
  # end
end
