# Usage:
#
#   Scale::Destination::Enumerable.send(:include, Analog::Reshaper::CedentMod::Enumerable)
#
# See: scale/destination/enumerable.rb
module Analog
  module Reshaper
    # Enhance the Analog Scale::Destination::Enumerable class to allow
    #   introspection into the precedent/succedent elements of the scale.
    module CedentMod
      module Enumerable
        def initialize(enum)
          @enum = enum.to_a
        end

        # Scale the given input and source using this destination
        # @param [Numeric] input A numeric value to scale
        # @param [Scale::Source] source The source for the input value
        # @return [Numeric]
        def scale(input, source)
          # Does not call super -
          #   we've already done everything that super would do, and more.
          proportion = source.numerator(input) / source.denominator
          @index = [((proportion * @enum.size).to_i - 1), 0].max
          @enum.at(@index)
        end
      end
    end
  end
end
