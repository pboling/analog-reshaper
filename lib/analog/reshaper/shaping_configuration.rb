module Analog
  module Reshaper
    class ShapingConfiguration
      # cumulative factor is either a product or a sum
      FACTOR_METHODS = %i[+ *].freeze
      # shaping area under the curve, vs shaping area over the curve
      COVERAGE_TYPES = %i[under over].freeze
      # The shaping config hash keys - are they antecedent or succedent in size?
      CUMULATIVE_DIRECTIONS = %i[antecedent succedent].freeze

      extend Forwardable
      extend Memoist

      attr_reader :cutoff_ranges, :factor_method, :coverage_type, :cumulative_direction, :sections

      def initialize(section_configs:, factor_method:, coverage_type:, cumulative_direction:)
        raise ArgumentError, "#{self.class}##{__method__} factor_method must be one of #{FACTOR_METHODS}" unless FACTOR_METHODS.include?(factor_method)
        raise ArgumentError, "#{self.class}##{__method__} coverage_type must be one of #{COVERAGE_TYPES}" unless COVERAGE_TYPES.include?(coverage_type)
        raise ArgumentError, "#{self.class}##{__method__} cumulative_direction must be one of #{CUMULATIVE_DIRECTIONS}" unless CUMULATIVE_DIRECTIONS.include?(cumulative_direction)

        @factor_method = factor_method
        @coverage_type = coverage_type
        @cumulative_direction = cumulative_direction

        rash = Hashie::Rash.new
        configs = Hashie::Rash.new(section_configs)
        @cutoff_ranges = configs.keys
        @sections = configs.each_with_object(rash).with_index do |((range, factors), rash), index|
          puts "section build: #{range} => #{factors}"
          cumulative = cumulative_by_direction(configs, index)
          puts "section build: cumulative => #{cumulative}"
          rash[range] = Analog::Reshaper::SectionConfiguration.new(range, factors, cumulative, @factor_method, @coverage_type, @cumulative_direction)
        end
      end

      def to_s
        "#{factor_method} #{coverage_type} cutoff_ranges: #{cutoff_ranges.ai}"
      end

      def inspect
        "<#Analog::Reshaper::SectionConfiguration #{__id__} #{self}>"
      end

      def minimum
        [cutoff_ranges.first.first, cutoff_ranges.last.first].min
      end
      memoize :minimum

      def maximum
        [cutoff_ranges.first.end, cutoff_ranges.last.end].max
      end
      memoize :maximum

      def [](value)
        sections[value]
      end

      def noop_modifier
        case factor_method
        when :+ then 0
        when :* then 1
        else
          raise "Invalid factor_method for #{self.class}##{__method__}"
        end
      end

      private

      def cumulative_by_direction(configs, index)
        # The cumulative factor is the product/sum of all factors of all prior sections.
        # It becomes the base factor on top of which the this section will be based.
        # There is no cumulative factor on the first section, because it is the first!
        case cumulative_direction
        when :antecedent
          if index > 0
            # index 4 of 5 element array has 4 antecedent indexes, [0, 1, 2, 3]
            # index 3 of 5 element array has 3 antecedent indexes, [0, 1, 2]
            # index 2 of 5 element array has 2 antecedent indexes, [0, 1]
            # index 1 of 5 element array has 1 antecedent indexes, [0]
            # Do not include index actual (...)
            cumulative_section_keys = @cutoff_ranges[0...index]
            # Hashie::Rash can be accessed by range key, or a value within the range.
            # Here we are accessing by the actual range keys
            configs.values_at(*cumulative_section_keys).flatten.inject(@factor_method)
          else
            # index 0 of 5 element array is first, so no antecedent indexes []
            # Multiplying by 1 has no effect!
            # Adding 0 has no effect!
            noop_modifier
          end
        when :succedent
          if index < (@cutoff_ranges.length - 1)
            # index 0 of 5 element array has 4 succedent indexes, [1, 2, 3, 4]
            # index 1 of 5 element array has 3 succedent indexes, [2, 3, 4]
            # index 2 of 5 element array has 2 succedent indexes, [3, 4]
            # index 3 of 5 element array has 1 succedent index, [4]
            # Do not include index actual
            cumulative_section_keys = @cutoff_ranges[(index + 1)..(-1)]
            # Hashie::Rash can be accessed by range key, or a value within the range.
            # Here we are accessing by the actual range keys
            configs.values_at(*cumulative_section_keys).flatten.inject(@factor_method)
          else
            # index 4 of 5 element array is last, so no succedent indexes []
            # Multiplying by 1 has no effect!
            # Adding 0 has no effect!
            noop_modifier
          end
        else
          raise "cummulative_by_direction for #{cumulative_direction} is not yet implemented"
        end
      end

      def addition?
        @factor_method == :+
      end
    end
  end
end
