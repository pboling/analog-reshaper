module Analog
  module Reshaper
    class SectionConfiguration
      extend Memoist
      extend Forwardable
      def_delegators :@shape_destination, :index, :proportion

      attr_reader :range, :factors, :cumulative, :factor_method,
                  :cumulative_direction, :value_source, :shape_destination
      def initialize(range, factors, cumulative, factor_method, cumulative_direction)
        # NOTE: always low to high, e.g.:
        #   => 0.94...0.98
        # Range#min returns nil if begin and end are the same value
        warn('Analog::Reshaper works best if section range.exclude_end? => true (... instead of ..) because: Math') if range.min && range.exclude_end?
        @range = range
        @factors = factors
        @cumulative = cumulative
        @factor_method = factor_method
        @cumulative_direction = cumulative_direction
        @value_source = Analog::Source.new(range)
        @shape_destination = Analog::Destination.new(factors)
      end

      def to_s
        range.to_s
      end

      def inspect
        "<#Analog::Reshaper::SectionConfiguration #{__id__} #{self} => #{factors.inspect} (#{factor_method} #{cumulative_direction})>"
      end

      # The factor where the next factor is not at all applicable.
      # The "partially" applicable factor may actually be 100% applicable.
      # The important thing is that the next factor is not at all.
      def factor_for_input(input)
        # This should set @index on shape_destination, and if not, we're FUBAR
        factor = shape_destination.scale(input, value_source)
        raise 'Failed to set index on shape_destination' unless shape_destination.index

        factor
      end

      def factor_portion
        raise 'Failed to set edge_finder on shape_destination' unless shape_destination.edge_finder
        shape_destination.edge_finder.find_edge(proportion).send("#{cumulative_direction}_portion")
      end

      # returns a numeric or nil
      def cedent_section_product
        shape_destination.send(cumulative_direction).inject(factor_method)
      end

      def first
        range.begin
      end
      alias low_end first

      def last
        range.end
      end
      alias high_end last

      # NOTE: positive difference between the high_end and low_end
      #   >> 0.9823687875519594 - 0.9445418534483248
      #   => 0.03782693410363469
      # This is not the same as range.size, which, in this use case,
      #   doesn't work well with Float
      def distance
        range.end - range.begin
      end

      private

      def factor_size
        return nil if factors.length.zero?

        distance / factors.length.to_f
      end
      memoize :factor_size
    end
  end
end
