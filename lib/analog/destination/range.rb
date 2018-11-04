module Analog
  # These are the classes that describe what range the transformed number
  # will wind up in. They're named after the core Ruby class that the input closest
  # resembles.
  module Destination
    # Contains logic for dealing with Ruby's core ::Range as input
    class Range
      # @param [::Range] range A range to operate with
      def initialize(range)
        @range = range
      end

      # Scale the given input and source using this destination
      # @param [Numeric] input A numeric value to scale
      # @param [Analog::Source] source The source for the input value
      # @return [Numeric]
      def scale(input, source)
        to_range_len = (@range.last - @range.first).abs

        proportion = to_range_len.to_f / source.denominator
        abs_output = proportion.to_f * source.numerator(input)
        output = abs_output + @range.first

        float_requested = [@range.first, @range.last].any? { |n| n.is_a?(::Float) }
        float_requested ? output : output.to_i
      end
    end
  end
end
