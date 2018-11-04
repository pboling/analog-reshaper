# frozen_string_literal: true

RSpec.describe Analog::Reshaper::Graduate do
  let(:input) { 10 }
  let(:factors) { [1.5, 2.0, 2.5] }
  let(:factor_method) { :* }
  let(:cumulative_direction) { :succedent }
  let(:section_configs) do
    {
      25...1000 => factors,
      12...25 => factors,
      6...12 => factors,
      2...6 => factors,
      1..1 => [1]
    }
  end
  let(:shaping_arguments) do
    {
      section_configs: section_configs,
      factor_method: factor_method,
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
            is_expected.to eq(120.0)
          end
        end
        context 'antecedent' do
          let(:cumulative_direction) { :antecedent }
          it 'is set' do
            is_expected.to be_a(Numeric)
            is_expected.to eq(577.5)
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
          is_expected.to be_a(Analog::Source::Range)
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
          is_expected.to be_a(Analog::Destination::Enumerable)
        end
        context '#antecedent' do
          subject { graduate.shape_destination.antecedent }
          it 'is set' do
            is_expected.to eq([1.5])
          end
        end
        context '#succedent' do
          subject { graduate.shape_destination.succedent }
          it 'is set' do
            is_expected.to eq([2.5])
          end
        end
        context '#index' do
          subject { graduate.shape_destination.index }
          it 'is set' do
            is_expected.to eq(1)
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
      context '#range' do
        subject { graduate.range }
        it 'is set' do
          is_expected.to eq(6...12)
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
      context '#percent_of_section_applicable_factor' do
        subject { graduate.percent_of_section_applicable_factor }
        it 'does not error' do
          block_is_expected.to_not raise_error
        end
        it 'is ratio' do
          is_expected.to eq(Rational(1, 1))
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
    let(:cumulative_direction) { :succedent }
    let(:section_configs) do
      {
        1..100 => [1.0]
      }
    end
    let(:input) { 101 }
    subject { graduate.output_value }
    it 'does not raise error' do
      block_is_expected.to_not raise_error
    end
    it 'returns shape maximum' do
      is_expected.to eq(100)
    end
  end

  context 'input outside low end of factor key range' do
    let(:factor_method) { :* }
    let(:cumulative_direction) { :succedent }
    let(:section_configs) do
      {
        10..100 => [1.0]
      }
    end
    let(:input) { 9 }
    subject { graduate.output_value }
    it 'does not raise error' do
      block_is_expected.to_not raise_error
    end
    it 'returns shape minimum' do
      is_expected.to eq(10)
    end
  end

  context 'input found missing middle section' do
    let(:factor_method) { :* }
    let(:cumulative_direction) { :succedent }
    let(:section_configs) do
      {
        1..8 => [1.2],
        10..100 => [1.2]
      }
    end
    let(:input) { 9 }
    subject { graduate.output_value }
    it 'does not raise error' do
      block_is_expected.to_not raise_error
    end
    it 'returns shape minimum' do
      is_expected.to eq(9)
    end
  end

  context 'factor :*, coverage :over, cumulative_direction :succedent, 1..100, 6 factors > 1' do
    {
      1 => 18.9408,
      2 => 37.73614545454546,
      3 => 56.386036363636364,
      4 => 74.89047272727272,
      5 => 93.24945454545455,
      6 => 111.46298181818182,
      7 => 129.53105454545454,
      8 => 147.45367272727273,
      9 => 165.23083636363637,
      10 => 182.86254545454548,
      20 => 277.1975757575758,
      30 => 390.34181818181827,
      40 => 357.52727272727276,
      50 => 398.4242424242425,
      60 => 309.8181818181818,
      70 => 268.54545454545456,
      80 => 209.93939393939394,
      90 => 120.00000000000001,
      99 => 13.200000000000003,
      100 => 100 # outside the range, so not reshaped!
    }.each do |k, v|
      context ":* #{k}" do
        let(:factor_method) { :* }
        let(:cumulative_direction) { :succedent }
        let(:section_configs) do
          {
            1...100 => [1.2, 1.4, 1.6, 1.8, 2.0, 2.2]
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

  context 'factor :*, coverage :over, cumulative_direction :antecedent, 1..100, 6 factors > 1' do
    {
        1 => 0,
        2 => 0.14545454545454545,
        3 => 0.43636363636363634,
        4 => 0.8727272727272727,
        5 => 1.4545454545454546,
        6 => 2.1818181818181817,
        7 => 3.0545454545454542,
        8 => 4.072727272727272,
        9 => 5.236363636363636,
        10 => 6.545454545454544,
        20 => 28.242424242424242,
        30 => 67.81818181818181,
        40 => 90.47272727272728,
        50 => 161.5757575757576,
        60 => 223.4618181818182,
        70 => 364.1425454545454,
        80 => 513.1326060606061,
        90 => 948.912,
        99 => 1162.6032,
        100 => 100 # outside the range, so not reshaped!
    }.each do |k, v|
      context ":* #{k}" do
        let(:factor_method) { :* }
        let(:cumulative_direction) { :antecedent }
        let(:section_configs) do
          {
              1...100 => [1.2, 1.4, 1.6, 1.8, 2.0, 2.2]
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

  context 'factor :*, coverage :over, cumulative_direction :succedent, 1..1_000, 3 factors > 1' do
    {
        1 => 1,
        2 => 15.0,
        3 => 19.125,
        4 => 18.0,
        5 => 14.375,
        6 => 84.0,
        7 => 92.75,
        8 => 112.0,
        9 => 99.0,
        10 => 120.0,
        11 => 96.25,
        12 => 753.0,
        13 => 811.25,
        14 => 868.8076923076923,
        15 => 925.6730769230769,
        16 => 981.8461538461538,
        17 => 1027.5192307692307,
        18 => 1079.6538461538462,
        19 => 1130.8653846153845,
        20 => 1181.1538461538462,
        21 => 1229.7115384615386,
        22 => 1275.576923076923,
        23 => 1320.2884615384614,
        24 => 1363.8461538461538,
        25 => 10709.375,
        50 => 21412.98076923077,
        75 => 32110.81730769231,
        100 => 42802.88461538462,
        200 => 85513.46153846153,
        300 => 128131.73076923077,
        400 => 170426.92307692306,
        500 => 212725.96153846153,
        600 => 254901.92307692306,
        700 => 296927.8846153846,
        800 => 338730.76923076925,
        900 => 380379.8076923077,
        1000 => 1000, # Outside the range!
    }.each do |k, v|
      context ":* #{k}" do
        let(:factor_method) { :* }
        let(:cumulative_direction) { :succedent }
        let(:section_configs) do
          {
              25...1000 => factors,
              12...25 => factors,
              6...12  => factors,
              2...6   => factors,
              1..1   => [1],
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

  context 'factor :*, coverage :over, cumulative_direction :succedent, 1..100_000, 11 factors > 1' do
    {
        # 1 => 3.7549218255960852,
        # 2 => 7.498282089630609,
        # 3 => 11.230080792103571,
        # 4 => 14.950317933014972,
        # 5 => 18.65899351236481,
        # 6 => 22.35610753015309,
        # 7 => 26.041659986379806,
        # 8 => 29.715650881044958,
        # 9 => 33.378080214148554,
        # 10 => 37.02894798569058,
        # 11 => 40.668254195671054,
        # 12 => 44.295998844089965,
        # 13 => 47.91218193094731,
        # 14 => 51.516803456243096,
        # 15 => 55.109863419977316,
        # 16 => 58.69136182214998,
        # 17 => 62.26129866276108,
        # 18 => 65.81967394181062,
        # 19 => 69.3664876592986,
        # 20 => 72.901739815225,
        # 21 => 76.42543040958986,
        # 22 => 79.93755944239317,
        # 23 => 83.43812691363489,
        # 24 => 86.92713282331506,
        # 25 => 90.40457717143366,
        # 50 => 173.58317836689136,
        # 75 => 249.53580358637305,
        # 100 => 318.2624528298788,
        # 200 => 702.0963423367688,
        # 300 => 878.069438430078,
        # 400 => 1297.7626149409818,
        # 500 => 1327.6587241316827,
        # 600 => 1779.9559174814274,
        # 700 => 1660.399020845449,
        800 => 2144.86828304016,
        # 900 => 1872.88672833009,
        # 1000 => 2391.713776,
    }.each do |k, v|
      context ":* #{k}" do
        let(:factors) { [1.05, 1.06, 1.07, 1.08, 1.09, 1.1, 1.11, 1.12, 1.13, 1.14, 1.15 ] }
        let(:factor_method) { :* }
        let(:cumulative_direction) { :succedent }
        let(:section_configs) do
          {
              26_000..100_000 => factors,
              13_000..25_999 => factors,
              6_000..12_999  => factors,
              2_000..5_999   => factors,
              1..1_999   => factors,
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
