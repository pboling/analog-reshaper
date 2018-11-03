# frozen_string_literal: true

RSpec.describe Analog::Reshaper::ShapingConfiguration do
  context 'antecedent shape' do
    let(:section_configs) do
      {
          1..1      => [1],
          2..10     => [1.5, 2.0, 2.5],
          11..100   => [1.5, 2.0, 2.5],
          101..1000 => [1.5, 2.0, 2.5],
      }
    end
    let(:factor_method) { :* }
    let(:cumulative_direction) { :antecedent }
    let(:arguments) do
      {
          section_configs: section_configs,
          factor_method: factor_method,
          cumulative_direction: cumulative_direction
      }
    end
    let(:shaping_configuration) { described_class.new(**arguments) }
    subject { shaping_configuration }
    describe '#initialize' do
      it 'does not error' do
        block_is_expected.to_not raise_error
      end
      context 'attributes' do
        context 'maximum' do
          subject { shaping_configuration.maximum }
          it 'is set' do
            is_expected.to be_a(Integer)
            is_expected.to eq(1000)
          end
        end
        context 'cutoff_ranges' do
          subject { shaping_configuration.cutoff_ranges }
          it 'is set' do
            is_expected.to be_a(Array)
            is_expected.to eq(section_configs.keys)
            expect(subject.first.end).to eq(1)
            expect(subject.last.end).to eq(1000)
          end
        end
        context 'factor_method' do
          subject { shaping_configuration.factor_method }
          it 'is set' do
            is_expected.to be_a(Symbol)
            is_expected.to eq(:*)
          end
        end
        context 'cumulative_direction' do
          subject { shaping_configuration.cumulative_direction }
          it 'is set' do
            is_expected.to be_a(Symbol)
            is_expected.to eq(:antecedent)
          end
        end
      end
    end
    describe '#maximum' do
      subject { shaping_configuration.maximum }
      it 'is 1000' do
        is_expected.to eq(1000)
      end
    end
    describe '#[]' do
      subject { shaping_configuration[11] }
      it 'is a section config' do
        is_expected.to be_a(Analog::Reshaper::SectionConfiguration)
      end
    end
  end
  context 'succedent shape' do
    let(:section_configs) do
      {
          101..1000 => [1.5, 2.0, 2.5],
          11..100   => [1.5, 2.0, 2.5],
          2..10     => [1.5, 2.0, 2.5],
          1..1      => [1],
      }
    end
    let(:factor_method) { :* }
    let(:cumulative_direction) { :antecedent }
    let(:arguments) do
      {
          section_configs: section_configs,
          factor_method: factor_method,
          cumulative_direction: cumulative_direction
      }
    end
    let(:shaping_configuration) { described_class.new(**arguments) }
    subject { shaping_configuration }
    describe '#initialize' do
      it 'does not error' do
        block_is_expected.to_not raise_error
      end
      context 'attributes' do
        context 'maximum' do
          subject { shaping_configuration.maximum }
          it 'is set' do
            is_expected.to be_a(Integer)
            is_expected.to eq(1000)
          end
        end
        context 'cutoff_ranges' do
          subject { shaping_configuration.cutoff_ranges }
          it 'is set' do
            is_expected.to be_a(Array)
            is_expected.to eq(section_configs.keys)
            expect(subject.first.end).to eq(1000)
            expect(subject.last.end).to eq(1)
          end
        end
        context 'factor_method' do
          subject { shaping_configuration.factor_method }
          it 'is set' do
            is_expected.to be_a(Symbol)
            is_expected.to eq(:*)
          end
        end
        context 'cumulative_direction' do
          subject { shaping_configuration.cumulative_direction }
          it 'is set' do
            is_expected.to be_a(Symbol)
            is_expected.to eq(:antecedent)
          end
        end
      end
    end
    describe '#maximum' do
      subject { shaping_configuration.maximum }
      it 'is 1000' do
        is_expected.to eq(1000)
      end
    end
    describe '#[]' do
      subject { shaping_configuration[11] }
      it 'is a section config' do
        is_expected.to be_a(Analog::Reshaper::SectionConfiguration)
      end
    end
  end
end
