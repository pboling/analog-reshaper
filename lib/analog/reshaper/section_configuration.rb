module Analog
  module Reshaper
    class SectionConfiguration
      ANTECEDENT_LINEAR_GRADATION_ENUM = (0..1000).to_a
      SUCCEDENT_LINEAR_GRADATION_ENUM = ANTECEDENT_LINEAR_GRADATION_ENUM.reverse
      ANTECEDENT_LINEAR_GRADUATION = Analog::Destination.new(ANTECEDENT_LINEAR_GRADATION_ENUM)
      SUCCEDENT_LINEAR_GRADUATION = Analog::Destination.new(SUCCEDENT_LINEAR_GRADATION_ENUM)
      extend Memoist
      extend Forwardable
      def_delegators :@shape_destination, :index

      attr_reader :range, :factors, :cumulative, :factor_method,
                  :cumulative_direction, :value_source, :shape_destination
      def initialize(range, factors, cumulative, factor_method, cumulative_direction)
        # NOTE: always low to high, e.g.:
        #   => 0.94...0.98
        # Range#min returns nil if begin and end are the same value
        warn('Analog::Reshaper works best if section range.exclude_end? => true (... instead of ..) because: Math') if range.min && range.exclude_end?
        @range = range
        @factors = factors
        @cumulative = cumulative
        @factor_method = factor_method
        @cumulative_direction = cumulative_direction
        @value_source = Analog::Source.new(range)
        @shape_destination = Analog::Destination.new(factors)
      end

      def to_s
        range.to_s
      end

      def inspect
        "<#Analog::Reshaper::SectionConfiguration #{__id__} #{self} => #{factors.inspect} (#{factor_method} #{cumulative_direction})>"
      end

      # The factor where the next factor is not at all applicable.
      # The "partially" applicable factor may actually be 100% applicable.
      # The important thing is that the next factor is not at all.
      def factor_for_input(input)
        # This should set @index on shape_destination, and if not, we're FUBAR
        factor = shape_destination.scale(input, value_source)
        raise 'Failed to set index on shape_destination' unless shape_destination.index

        factor
      end

      def portion(input)
        send("#{cumulative_direction}_portion", input)
      end

      def factor_portion(input)
        send("#{cumulative_direction}_factor_portion", input)
      end

      # returns a numeric or nil
      def cedent_section_product
        shape_destination.send(cumulative_direction).inject(factor_method)
      end

      def first
        range.begin
      end
      alias low_end first

      def last
        range.end
      end
      alias high_end last

      # NOTE: positive difference between the high_end and low_end
      #   >> 0.9823687875519594 - 0.9445418534483248
      #   => 0.03782693410363469
      # This is not the same as range.size, which, in this use case,
      #   doesn't work well with Float
      def distance
        range.end - range.begin
      end

      private

      # How much of the applicable factor is actually applicable
      # > 0% up to 100% as a Rational, like (310/1000) for 31.0%
      def antecedent_portion(input_value)
        Rational(ANTECEDENT_LINEAR_GRADUATION.scale(input_value, value_source), 1000)
      end

      # How much of the applicable factor is actually applicable
      # > 0% up to 100% as a Rational, like (310/1000) for 31.0%
      def succedent_portion(input_value)
        Rational(SUCCEDENT_LINEAR_GRADUATION.scale(input_value, value_source), 1000)
      end

      def factor_size
        return nil if factors.length.zero?

        distance / factors.length.to_f
      end
      memoize :factor_size

      # If each factor covers the same amount of the range,
      # then we don't need to actually find the real range
      def anonymous_factor_source
        return nil if factor_size.nil? || factor_size <= 0

        Analog::Source.new(0..factor_size)
      end
      memoize :anonymous_factor_source

      def anonymous_factor_coverage(input_value)
        case cumulative_direction
        when :succedent then
          # |---------F++++++++|
          Rational(factor_size - input_value.modulo(factor_size), factor_size)
        when :antecedent then
          # |+++++++++F--------|
          Rational(input_value.modulo(factor_size), factor_size)
        else
          raise 'invalid cumulative_direction for anonymous_factor_coverage'
        end
      end

      # How much of the applicable factor is actually applicable
      # > 0% up to 100% as a Rational, like (310/1000) for 31.0%
      def antecedent_factor_portion(input_value)
        return 0 unless anonymous_factor_source

        Rational(
          ANTECEDENT_LINEAR_GRADUATION.scale(
            anonymous_factor_coverage(input_value),
            anonymous_factor_source
          ),
          1000
        )
      end

      # How much of the applicable factor is actually applicable
      # > 0% up to 100% as a Rational, like (310/1000) for 31.0%
      def succedent_factor_portion(input_value)
        return 0 unless anonymous_factor_source

        Rational(
          SUCCEDENT_LINEAR_GRADUATION.scale(
            anonymous_factor_coverage(input_value),
            anonymous_factor_source
          ),
          1000
        )
      end
    end
  end
end
