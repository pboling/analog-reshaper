module Analog
  module Reshaper
    class SectionConfiguration
      attr_reader :range, :factors, :cumulative, :factor_method, :coverage_type
      def initialize(range, factors, cumulative, factor_method, coverage_type)
        # NOTE: always low to high, e.g.:
        #   => 0.94..0.98
        @range = range
        @factors = factors
        @cumulative = cumulative
        @factor_method = factor_method
        @coverage_type = coverage_type
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

      def to_s
        range.to_s
      end

      def inspect
        "<#Analog::Reshaper::SectionConfiguration #{__id__} #{self} => #{factors.inspect} (#{factor_method} #{coverage_type})>"
      end
    end
  end
end
