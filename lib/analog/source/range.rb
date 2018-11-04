module Analog
  # These are the classes that describe what range the transformed number
  # starts in.  They're named after the core Ruby class that the input closest
  # resembles.
  module Source
    # Contains logic for dealing with Ruby's core ::Range as input
    class Range
      # @param [::Range] range A range to operate on
      def initialize(range)
        @range = range
      end

      def proportion(input)
        Rational(numerator(input), denominator)
      end

      # @param [Numeric] input
      # @return [Float]
      def numerator(input)
        input - @range.first
      end

      # @return [Float]
      def denominator
        # Range#min is nil if last and first are the same value and @range.exclude_end? => true.
        if !@range.exclude_end? || @range.min
          den = (@range.last - @range.first).abs
          den.zero? ? 1 : den
        else
          1
        end
      end
    end
  end
end
