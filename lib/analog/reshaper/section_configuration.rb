module Analog
  module Reshaper
    class SectionConfiguration
      ANTECEDENT_LINEAR_GRADATION_ENUM = (0..100).to_a
      SUCCEDENT_LINEAR_GRADATION_ENUM = ANTECEDENT_LINEAR_GRADATION_ENUM.reverse
      ANTECEDENT_LINEAR_GRADUATION = Scale::Destination.new(ANTECEDENT_LINEAR_GRADATION_ENUM)
      SUCCEDENT_LINEAR_GRADUATION = Scale::Destination.new(SUCCEDENT_LINEAR_GRADATION_ENUM)

      attr_reader :range, :factors, :cumulative, :factor_method, :coverage_type,
                  :cumulative_direction, :value_source, :shape_destination
      def initialize(range, factors, cumulative, factor_method, coverage_type, cumulative_direction)
        # NOTE: always low to high, e.g.:
        #   => 0.94..0.98
        @range = range
        @factors = factors
        @cumulative = cumulative
        @factor_method = factor_method
        @coverage_type = coverage_type
        @cumulative_direction = cumulative_direction
        @value_source = Scale::Source.new(range)
        @shape_destination = Scale::Destination.new(factors)
      end

      def to_s
        range.to_s
      end

      def inspect
        "<#Analog::Reshaper::SectionConfiguration #{__id__} #{self} => #{factors.inspect} (#{factor_method} #{coverage_type})>"
      end

      # The factor where the next factor is not at all applicable.
      # The "partially" applicable factor may actually be 100% applicable.
      # The important thing is that the next factor is not at all.
      def factor_for_input(input)
        shape_destination.scale(input, value_source)
      end

      def portion(input)
        send("#{cumulative_direction}_portion", input)
      end

      def first
        range.begin
      end

      def last
        range.end
      end

      # NOTE: positive difference between the high_end and low_end
      #   >> 0.9823687875519594 - 0.9445418534483248
      #   => 0.03782693410363469
      def distance
        range.last - range.first
      end

      private

      # How much of the applicable factor is actually applicable
      # > 0% up to 100% as a Rational, like (31/100) for 31%
      def antecedent_portion(input_value)
        Rational(ANTECEDENT_LINEAR_GRADUATION.scale(input_value, value_source), 100)
      end

      # How much of the applicable factor is actually applicable
      # > 0% up to 100% as a Rational, like (31/100) for 31%
      def succedent_portion(input_value)
        Rational(SUCCEDENT_LINEAR_GRADUATION.scale(input_value, value_source), 100)
      end
    end
  end
end
