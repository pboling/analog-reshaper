module Analog
  module Reshaper
    # Enhance the Analog Scale::Destination classes to allow
    #   introspection into the precedent/succedent elements of the scale.
    module CedentMod
      module Cedent
        def index
          @index
        end

        def cedent_calculable?
          @index && @index > 0 ? true : false
        end

        def antecedent
          cedent_calculable? ? @enum.values_at(0...@index) : []
        end

        def succedent
          cedent_calculable? ? @enum.values_at((@index + 1)..(-1)) : []
        end
      end
    end
  end
end
