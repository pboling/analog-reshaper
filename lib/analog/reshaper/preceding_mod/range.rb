# Usage:
#
#   Scale::Destination::Range.send(:include, Analog::Reshaper::PrecedingMod::Range)
#
# See: scale/destination/range.rb
module Analog
  module Reshaper
    # Enhance the Analog Scale::Destination::Enumerable class to allow
    #   introspection into the preceding elements of the scale.
    module PrecedingMod
      module Range
        def initialize(range)
          super
          @float_requested = [@range.first, @range.last].any? { |n| n.kind_of?(::Float) }
          @enum = @float_requested ? nil : @range.to_a
        end

        # Scale the given input and source using this destination
        # @param [Numeric] input A numeric value to scale
        # @param [Scale::Source] source The source for the input value
        # @return [Numeric]
        def scale(input, source)
          if @float_requested
            to_range_len = (@range.last - @range.first).abs
            proportion = to_range_len.to_f / source.denominator
            abs_output = proportion.to_f * source.numerator(input)
            output = abs_output + @range.first
            output
          else
            # If float is not requested, then process as an enum
            proportion = source.numerator(input) / source.denominator
            @index = [((proportion * @enum.size).to_i - 1), 0].max
            @enum.to_a.at(@index)
          end
        end

        def preceding_calculable?
          !@float_requested
        end

        def index
          @float_requested ? nil : @index
        end

        def preceding
          @float_requested ? nil : @enum.values_at(0...@index)
        end
      end
    end
  end
end
