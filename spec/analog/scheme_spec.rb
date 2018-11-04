RSpec.describe Analog::Scheme do
  describe '.transform' do
    context 'range destination' do
      context 'float range source' do
        {
            0 => 0,
            0.1 => 12,
            0.2 => 25,
            0.3 => 38,
            0.4 => 50,
            0.5 => 63,
            0.6 => 76,
            0.7 => 88,
            0.8 => 101,
            0.9 => 114,
            1.0 => 127,
            1 => 127
        }.each do |input, output|
          context input.to_s do
            let(:input_value) { input }
            subject { Analog.transform(input_value).using(0.0..1.0, 0..127) }
            it "becomes #{output}" do
              is_expected.to eq(output)
            end
          end
        end
      end
      context 'integer range source' do
        {
            0 => 0,
            1 => 12,
            2 => 25,
            3 => 38,
            4 => 50,
            5 => 63,
            6 => 76,
            7 => 88,
            8 => 101,
            9 => 114,
            10 => 127
        }.each do |input, output|
          context input.to_s do
            let(:input_value) { input }
            subject { Analog.transform(input_value).using(0..10, 0..127) }
            it "becomes #{output}" do
              is_expected.to eq(output)
            end
          end
        end
      end
      context 'integer enumerable source' do
        {
            0 => 0,
            1 => 12,
            2 => 25,
            3 => 38,
            4 => 50,
            5 => 63,
            6 => 76,
            7 => 88,
            8 => 101,
            9 => 114,
            10 => 127
        }.each do |input, output|
          context input.to_s do
            let(:input_value) { input }
            subject { Analog.transform(input_value).using((0..10).to_a, 0..127) }
            it "becomes #{output}" do
              is_expected.to eq(output)
            end
          end
        end
      end
      context 'float enumerable source' do
        {
            0 => 0,
            0.1 => 12,
            0.2 => 25,
            0.3 => 38,
            0.4 => 50,
            0.5 => 63,
            0.6 => 76,
            0.7 => 88,
            0.8 => 101,
            0.9 => 114,
            1.0 => 127
        }.each do |input, output|
          context input.to_s do
            let(:input_value) { input }
            let(:source) { (0..10).to_a.map { |x| x / 10.0 } }
            subject { Analog.transform(input_value).using(source, 0..127) }
            it "becomes #{output}" do
              is_expected.to eq(output)
            end
          end
        end
      end
      context 'rational enumerable source' do
        {
            0 => 0,
            0.1 => 12,
            0.2 => 25,
            0.3 => 38,
            0.4 => 50,
            0.5 => 63,
            0.6 => 76,
            0.7 => 88,
            0.8 => 101,
            0.9 => 114,
            1.0 => 127
        }.each do |input, output|
          context input.to_s do
            let(:input_value) { input }
            let(:source) { (0..10).to_a.map { |x| Rational(x, 10) } }
            subject { Analog.transform(input_value).using(source, 0..127) }
            it "becomes #{output}" do
              is_expected.to eq(output)
            end
          end
        end
      end
    end
    context 'enum destination' do
      context 'float range source' do
        {
            0 => 1,
            0.05 => 1,
            0.1 => 2,
            0.15 => 2,
            0.16 => 2,
            0.17 => 2,
            0.18 => 2,
            0.19 => 2,
            0.2 => 3,
            0.25 => 3,
            0.3 => 3,
            0.30000001 => 4,
            0.35 => 4,
            0.4 => 5,
            0.45 => 5,
            0.45000001 => 5,
            0.46 => 5,
            0.47 => 5,
            0.48 => 5,
            0.49 => 5,
            0.49999999 => 5,
            0.5 => 5,
            0.50000001 => 6,
            0.54 => 6,
            0.54999999 => 6,
            0.55 => 6,
            0.6 => 6,
            0.60000001 => 7,
            0.65 => 7,
            0.7 => 7,
            0.70000001 => 8,
            0.75 => 8,
            0.79999999 => 8,
            0.8 => 9,
            0.80000001 => 9,
            0.85 => 9,
            0.9 => 10,
            0.95 => 10,
            0.99 => 10,
            0.9999999999999999 => 10,
            1.0 => 10,
            1 => 10,
            1.01 => nil,
            2 => nil
        }.each do |input, output|
          context input.to_s do
            let(:input_value) { input }
            subject { Analog.transform(input_value).using(0.0...1.0, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]) }
            it "becomes #{output}" do
              is_expected.to eq(output)
            end
          end
        end
      end
      # context 'integer range source' do
      #   {
      #       0 => 0,
      #       1 => 1,
      #       2 => 2,
      #       3 => 3,
      #       4 => 4,
      #       5 => 5,
      #       6 => 6,
      #       7 => 7,
      #       8 => 8,
      #       9 => 9,
      #       10 => 10
      #   }.each do |input, output|
      #     context input.to_s do
      #       let(:input_value) { input }
      #       subject { Analog.transform(input_value).using(0...10, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]) }
      #       it "becomes #{output}" do
      #         is_expected.to eq(output)
      #       end
      #     end
      #   end
      # end
      # context 'integer enumerable source' do
      #   {
      #       0 => 0,
      #       1 => 1,
      #       2 => 2,
      #       3 => 3,
      #       4 => 4,
      #       5 => 5,
      #       6 => 6,
      #       7 => 7,
      #       8 => 8,
      #       9 => 9,
      #       10 => 10
      #   }.each do |input, output|
      #     context input.to_s do
      #       let(:input_value) { input }
      #       subject { Analog.transform(input_value).using((0...10).to_a, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]) }
      #       it "becomes #{output}" do
      #         is_expected.to eq(output)
      #       end
      #     end
      #   end
      # end
      # context 'float enumerable source' do
      #   {
      #       0 => 0,
      #       0.1 => 1,
      #       0.2 => 2,
      #       0.3 => 3,
      #       0.4 => 4,
      #       0.5 => 5,
      #       0.6 => 6,
      #       0.7 => 7,
      #       0.8 => 8,
      #       0.9 => 9,
      #       1.0 => 1.0
      #   }.each do |input, output|
      #     context input.to_s do
      #       let(:input_value) { input }
      #       let(:source) { (0...10).to_a.map { |x| x / 10.0 } }
      #       subject { Analog.transform(input_value).using(source, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]) }
      #       it "becomes #{output}" do
      #         is_expected.to eq(output)
      #       end
      #     end
      #   end
      # end
      # context 'rational enumerable source' do
      #   {
      #       0 => 0,
      #       0.1 => 1,
      #       0.2 => 2,
      #       0.3 => 3,
      #       0.4 => 4,
      #       0.5 => 5,
      #       0.6 => 6,
      #       0.7 => 7,
      #       0.8 => 8,
      #       0.9 => 9,
      #       1.0 => 1.0
      #   }.each do |input, output|
      #     context input.to_s do
      #       let(:input_value) { input }
      #       let(:source) { (0...10).to_a.map { |x| Rational(x, 10) } }
      #       subject { Analog.transform(input_value).using(source, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]) }
      #       it "becomes #{output}" do
      #         is_expected.to eq(output)
      #       end
      #     end
      #   end
      # end
    end
  end
end
