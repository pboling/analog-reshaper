module Analog
  # These are the classes that describe what range the transformed number
  # will wind up in. They're named after the core Ruby class that the input closest
  # resembles.
  module Destination
    # Contains logic for dealing with input that includes Ruby's core ::Enumerable
    class Enumerable
      # @param [::Enumerable] enum An enumerable (eg Array, Set) to operate with
      def initialize(enum)
        # @enum = enum
        @enum = enum.to_a
      end

      # Analog the given input and source using this destination
      # @param [Numeric] input A numeric value to scale
      # @param [Analog::Source] source The source for the input value
      # @return [Numeric]
      def scale(input, source)
        proportion = source.numerator(input) / source.denominator
        @index = [((proportion * @enum.size).to_i - 1), 0].max
        @enum.at(@index)
      end

      def index
        @index
      end

      def antecedent
        @index && @index > 0 ? @enum.values_at(0...@index) : []
      end

      def succedent
        @index && @index < (@enum.size - 1) ? @enum.values_at((@index + 1)..-1) : []
      end
    end
  end
end
