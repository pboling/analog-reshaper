module Analog
  # These are the classes that describe what range the transformed number
  # will wind up in. They're named after the core Ruby class that the input closest
  # resembles.
  module Destination
    # Contains logic for dealing with input that includes Ruby's core ::Enumerable
    class Enumerable
      attr_reader :index, :edge_finder, :proportion, :edge
      # @param [::Enumerable] enum An enumerable (eg Array, Set) to operate with
      def initialize(enum)
        # Add a bogus nil to the enum in initialize,
        #   to right size the mapping to the enum, and need to shunt the
        #   matches to the nil to the last real element of enum
        @enum = enum.to_a
        @size = @enum.size
        raise ArgumentError, "enum must have size > 0" unless @size > 0
        @edge_finder = Analog::Reshaper::EdgeFinder.lookup(@size)
      end

      # Scale the given input and source using this destination
      # @param [Numeric] input A numeric value to scale
      # @param [Analog::Source] source The source for the input value
      # @return [Numeric]
      def scale(input, source)
        @proportion = source.proportion(input)
        if @proportion
          @edge = @edge_finder.find_edge(@proportion)
          @index = @edge.index
          @enum.at(@index)
        else
          input
        end
      end

      def antecedent
        @index && @index > 0 ? @enum.values_at(0...@index) : []
      end

      def succedent
        @index && @index < (@enum.size - 1) ? @enum.values_at((@index + 1)..-1) : []
      end

      private

      def sizer(proportion, units)
        finder_sizer = Rational(units, proportion.denominator)
        proportion.numerator * finder_sizer
      end
    end
  end
end
