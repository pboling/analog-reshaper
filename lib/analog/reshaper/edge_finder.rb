module Analog
  module Reshaper
    class EdgeFinder
      class << self
        attr_reader :cache_store
        def lookup(power)
          cache_store[power]
        end
      end
      @cache_store = Hash.new do |h, power|
        h[power] = Analog::Reshaper::EdgeFinder.new(power: power)
      end

      attr_reader :base_units, :units_per
      def initialize(power:)
        @base_units = 10**Math.log(power)
        @units_per = sizer(Rational(1, power))
      end

      def find_edge(value)
        units = sizer(value)
        Analog::Reshaper::Edge.new(units: units, units_per: units_per)
      end

      private

      # We need to get the numerator over 10**Math.log(enum.size)
      # So for an enum of size 2...
      # >> proportion = Rational(3,10)
      # => (3/10)
      # >> index_finder_precision_units = 10**Math.log(@enum.size)
      # => 4.933409667914596
      # >> sizer = Rational(index_finder_precision_units, a.denominator)
      # => (694315685690193/1407374883553280)
      # >> sized = a.numerator * sizer
      # => (2082947057070579/1407374883553280)
      # >> sized.to_f
      # => 1.4800229003743788
      def sizer(proportion)
        finder_sizer = Rational(base_units, proportion.denominator)
        proportion.numerator * finder_sizer
      end
    end
  end
end
