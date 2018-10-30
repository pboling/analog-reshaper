module Analog
  module Reshaper
    class ShapingConfiguration
      # cumulative factor is either a product or a sum
      FACTOR_METHODS = %i[+ *].freeze
      # shaping area under the curve, vs shaping area over the curve
      COVERAGE_TYPES = %i[under over].freeze

      extend Forwardable
      extend Memoist

      attr_reader :cutoff_ranges, :factor_method, :coverage_type, :sections

      def initialize(section_configs:, factor_method:, coverage_type:)
        raise ArgumentError, "#{self.class}##{__method__} factor_method must be one of #{FACTOR_METHODS}" unless FACTOR_METHODS.include?(factor_method)
        raise ArgumentError, "#{self.class}##{__method__} coverage_type must be one of #{COVERAGE_TYPES}" unless COVERAGE_TYPES.include?(coverage_type)

        @factor_method = factor_method
        @coverage_type = coverage_type

        rash = Hashie::Rash.new
        configs = Hashie::Rash.new(section_configs)
        @cutoff_ranges = configs.keys
        @sections = configs.each_with_object(rash).with_index do |((range, factors), rash), index|
          # The cumulative factor is the product/sum of all factors of all prior sections.
          # It becomes the base factor on top of which the this section will be based.
          # There is no cumulative factor on the first section, because it is the first!
          cumulative = if index > 0
                         cumulative_section_keys = @cutoff_ranges[0..(index - 1)]
                         # Hashie::Rash can be accessed by range key, or a value within the range.
                         # Here we are accessing by the actual range keys
                         configs.values_at(*cumulative_section_keys).flatten.inject(@factor_method)
                       else
                         # Multiplying by 1 has no effect!
                         addition? ? 0 : 1
                       end
          rash[range] = Analog::Reshaper::SectionConfiguration.new(range, factors, cumulative, @factor_method, @coverage_type)
        end
      end

      def maximum
        cutoff_ranges.map(&:end).max
      end
      memoize :maximum

      def [](value)
        sections[value]
      end

      private

      def addition?
        @coverage_type == :+
      end
    end
  end
end
