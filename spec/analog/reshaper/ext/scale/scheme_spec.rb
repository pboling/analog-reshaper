RSpec.describe Scale::Scheme do
  describe ".transform" do
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
        context "#{input}" do
          let(:input_value) { input }
          subject { Scale.transform(input_value).using(0.0..1.0, 0..127) }
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
        context "#{input}" do
          let(:input_value) { input }
          subject { Scale.transform(input_value).using(0..10, 0..127) }
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
        context "#{input}" do
          let(:input_value) { input }
          subject { Scale.transform(input_value).using((0..10).to_a, 0..127) }
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
        context "#{input}" do
          let(:input_value) { input }
          let(:source) { (0..10).to_a.map { |x| x / 10.0 } }
          subject { Scale.transform(input_value).using(source, 0..127) }
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
        context "#{input}" do
          let(:input_value) { input }
          let(:source) { (0..10).to_a.map { |x| Rational(x, 10) } }
          subject { Scale.transform(input_value).using(source, 0..127) }
          it "becomes #{output}" do
            is_expected.to eq(output)
          end
        end
      end
    end
  end
end
