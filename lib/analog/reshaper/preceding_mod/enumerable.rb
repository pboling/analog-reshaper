# Usage:
#
#   Scale::Destination::Enumerable.send(:include, Analog::Reshaper::PrecedingMod::Enumerable)
#
# See: scale/destination/enumerable.rb
module Analog
  module Reshaper
    # Enhance the Analog Scale::Destination::Enumerable class to allow
    #   introspection into the preceding elements of the scale.
    module PrecedingMod
      module Enumerable
        # Scale the given input and source using this destination
        # @param [Numeric] input A numeric value to scale
        # @param [Scale::Source] source The source for the input value
        # @return [Numeric]
        def scale(input, source)
          # Does not call super -
          #   we've already done everything that super would do, and more.
          proportion = source.numerator(input) / source.denominator
          @index = [((proportion * @enum.size).to_i - 1), 0].max
          @enum.to_a.at(@index)
        end

        def index
          @index
        end

        def preceding_calculable?
          true
        end

        def preceding
          @enum.to_a.values_at(0...@index)
        end
      end
    end
  end
end
