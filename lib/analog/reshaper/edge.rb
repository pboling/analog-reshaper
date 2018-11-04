module Analog
  module Reshaper
    class Edge
      attr_reader :index, :remainder, :units_per
      def initialize(units:, units_per:)
        @units_per = units_per
        @index, @remainder = units.divmod(units_per)
        # We have to push the index back by one unless there is a remainder
        # This is because indexes start at 0, and we want 0.78 units to map to
        #   the 0 index, and 1.23 units to map to index 1 (the second index)
        # Also, if the index is 0 we can't get lower!
        if @index > 0
          @index -= 1 unless @remainder > 0
        end
      end

      def antecedent_portion
        Rational(@remainder, @units_per)
      end

      def succedent_portion
        Rational(@units_per - @remainder, @units_per)
      end
    end
  end
end
