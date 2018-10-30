module Analog
  module Reshaper
    class Graduate
      extend Forwardable
      extend Memoist
      def_delegators :@shaping_config, :maximum, :factor_method, :coverage_type
      def_delegators :@section, :range, :factors, :cumulative, :distance, :first, :last
      attr_reader :input_value, :output_value, :shaping_config, :section
      def initialize(input:, shaping_config:)
        @input_value = input
        @shaping_config = shaping_config
        @section = self.shaping_config[input]
        @output_value = reshaped
      end

      def to_i
        output_value.to_i
      end

      def to_f
        output_value.to_f
      end

      private

      # given a value between 0 and 1, within the range of this section,
      #   return the rescaled value
      def reshaped
        if :over
          raise "DivideByZero Error in #{self.class}##{__method__} for input_value #{input_value} with #{section}" if denominator == 0

          Rational(maximum, denominator).to_i
        else
          # TODO: Figure out :under logic
          # (rank + (rank * factor(input_value))).to_i
        end
      end

      # e.g.
      #   numerator is:          549_547_150_329
      #                                        /
      #   denominator is:                  1_000
      #                                        =
      #   if final value is:         549_547_150
      #
      def denominator
        # If the input_value is 0.3999:
        #   factors_fully_not_covered = 3
        # which is used as an index into the sectioned factors of this range, e.g:
        #   >> section_factors.map(&:to_s)
        #   => ["1.21", "1.21", "4.0", "1.3", "1.3", "1.3", "1.3", "1.3", "1.3"]
        # With this example:
        #   fully_not_covered_factor is 1.21 * 1.21 * 3.0 * all factors of previous sections.
        #   partially_not_covered_factor is (1 + ((1.3 - 1) * 0.3999))
        fully_not_covered_factor * partially_not_covered_factor
      end
      memoize :denominator

      def partially_not_covered_factor
        partial_factor = factors[partially_not_covered_factor_index]
        if partial_factor.nil?
          1
        else
          # modify the partial factor relative to the portion not_covered.
          1 + ((partial_factor - 1) * section_not_covered_ratio)
        end
      end
      memoize :partially_not_covered_factor

      def fully_not_covered_factor
        if fully_not_covered_factor_index.nil?
          cumulative
        else
          # where factor_method is one of :* or :+
          cumulative.send(factor_method, fully_not_covered_factors.inject(factor_method))
        end
      end

      def fully_not_covered_factors
        factors[0..fully_not_covered_factor_index]
      end

      def fully_not_covered_factor_index
        if section_fully_not_covered?
          # :all factors: #
          num_factors
        else
          # :partial: #
          return num_factors if partially_not_covered_factor_index > num_factors
          return nil if partially_not_covered_factor_index < 1

          partially_not_covered_factor_index - 1
        end
      end
      memoize :fully_not_covered_factor_index

      # returns an integer
      def partially_not_covered_factor_index
        if portion_per_factor == 0
          1
        else
          Rational(distance_not_covered, portion_per_factor).to_i
        end
      end
      memoize :partially_not_covered_factor_index

      def distance_not_covered
        distance * section_not_covered_ratio
      end

      # What is the coverage size of each factor?
      def portion_per_factor
        if num_factors == 0
          1
        else
          Rational(distance, num_factors)
        end
      end
      memoize :portion_per_factor

      def num_factors
        factors.length
      end

      # All factors are fully not_covered if true!
      # Technically this should not happen, as if it did it should have bumped
      #   up to the next partially not_covered section.
      def section_fully_not_covered?
        section_not_covered_ratio == 1
      end

      # Total amount of this section that is not_covered, as a ratio between 0 and 1
      def section_not_covered_ratio
        if distance == 0
          1
        else
          Rational(incomplete, distance)
        end
      end
      memoize :section_not_covered_ratio

      def complete
        input_value - low_end
      end

      def incomplete
        high_end - input_value
      end

      def high_end
        last
      end

      def low_end
        first
      end

      ### Useful for debugging ###

      def percentage_per_factor
        portion_per_factor * 100
      end
    end
  end
end
