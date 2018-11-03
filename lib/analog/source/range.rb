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

      # @param [Numeric] input
      # @return [Float]
      def numerator(input)
        (input - @range.first).to_f
      end

      # @return [Float]
      def denominator
        (@range.last - @range.first).abs.to_f
      end
    end
  end
end
