module Analog
  # These are the classes that describe what range the transformed number
  # starts in.  They're named after the core Ruby class that the input closest
  # resembles.
  module Source
    # Contains logic for dealing with input that includes Ruby's core ::Enumerable
    class Enumerable
      # @param [::Enumerable] enum An enumerable (Array, Set, etc) to operate on
      def initialize(enum)
        @enum = enum.to_a
      end

      def proportion(input)
        Rational(numerator(input), denominator)
      end

      # @param [Numeric] input
      # @return [Float]
      def numerator(input)
        @enum.index(input).to_f
      end

      # @return [Float]
      def denominator
        (@enum.size - 1).to_f
      end
    end
  end
end
