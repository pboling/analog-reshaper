module Analog
  module Reshaper
    # Purpose:
    #
    # 1. Find the input value on the value source range
    # 2. Map it to the
    class Graduate
      extend Forwardable
      extend Memoist
      def_delegators :@shaping_config, :maximum, :minimum, :factor_method,
                     :cumulative_direction, :noop_modifier
      def_delegators :@section, :range, :factors, :cumulative, :distance,
                     :first, :last, :value_source, :shape_destination,
                     :factor_for_input, :portion
      attr_reader :input_value,
                  :output_value,
                  :shaping_config,
                  :section,
                  :applicable_factor,
                  :portion_of_section,
                  :section_applicable_factor,
                  :portion_of_section_applicable_factor,
                  :num_antecedent_sections_by_shape
      def initialize(input:, shaping_config:)
        @input_value = input
        puts "#{self.class} input_value: #{@input_value}"
        @shaping_config = shaping_config
        puts "#{self.class} shaping_config: #{@shaping_config.ai}"
        @section = @shaping_config[@input_value]
        puts "#{self.class} section: #{@section.inspect.green}"
        if @section && factors.any?
          @applicable_factor = factor_for_input(input)
          puts "#{self.class} applicable_factor: #{@applicable_factor}"
          @portion_of_section = portion(@input_value)
          puts "#{self.class} portion_of_section: #{@portion_of_section}"
          # The factor method, e.g. :*, is the manner the various factors are applied to the input_value
          #   cumulative - the product, or sum, of all the antecedent or succedent sections' factors
          #
          # cumulative: product of factors due to :* handling in section config
          # cumulative: sum of factors due to :+ handling in section config
          # in modifying the input value:
          # 1. modify it according to the cumulative, which forms the "cedent_base"
          #   input_value.send(factor_method, cumulative)
          # 2. modify it according to the relevant section's cedent factors
          #   input_value.send(factor_method, cumulative_cedent_factor)
          # 3. modify it according to the portion of applicable factor
          #   input_value.send(factor_method, cumulative_cedent_factor * applicable_factor)
          puts "====== NOT SURE WHAT TO DO HERE ======"
          @input_modified_by_cedent_cumulative_base_product = cumulative ? input_value.send(factor_method, cumulative) : 0
          puts "#{self.class} input_modified_by_cedent_cumulative_base_product: #{@input_modified_by_cedent_cumulative_base_product}"
          @num_antecedent_factors_by_shape = shape_destination.antecedent.length
          puts "#{self.class} num_antecedent_factors_by_shape: #{@num_antecedent_factors_by_shape}"
          cedent_section_product = shape_destination.send(cumulative_direction).inject(factor_method)
          puts "#{self.class} cedent_section_product: #{cedent_section_product}"
          @input_modified_by_covered_section_shape = cedent_section_product ? input_value.send(factor_method, cedent_section_product) : 0
          puts "#{self.class} input_modified_by_covered_section_shape: #{@input_modified_by_covered_section_shape}"

          # How much of the applicable factor is actually applicable?
          distance_per_factor = distance / factors.length
          puts"#{self.class} distance_per_factor: #{distance_per_factor}"
          num_antecedent_factors, factor_distance_covered = input.divmod(distance_per_factor)
          puts"#{self.class} num_antecedent_factors: #{num_antecedent_factors}"
          if num_antecedent_factors == @num_antecedent_factors_by_shape
            # This is best case scenario, the input was mapped to the factor that applies linearly, percentage-wise
            percent_of_applicable_factor = Rational(factor_distance_covered, distance_per_factor)
            @portion_of_section_applicable_factor = applicable_factor * percent_of_applicable_factor
            puts "#{self.class} portion_of_section_applicable_factor: #{@portion_of_section_applicable_factor}"
            @section_applicable_factor = @partial_factor ? input_value.send(factor_method, @portion_of_section_applicable_factor) : 0
            puts "#{self.class} section_applicable_factor: #{@section_applicable_factor}"
          elsif num_antecedent_factors > @num_antecedent_factors_by_shape
            # This is fairly common because the scale gem does't align linearly, perfectly, every time.
            percent_of_applicable_factor = Rational(factor_distance_covered, distance_per_factor)
            @portion_of_section_applicable_factor = applicable_factor * percent_of_applicable_factor
            puts "#{self.class} portion_of_section_applicable_factor: #{@portion_of_section_applicable_factor}"
            @section_applicable_factor = @partial_factor ? input_value.send(factor_method, @portion_of_section_applicable_factor) : 0
            puts "#{self.class} section_applicable_factor: #{@section_applicable_factor}"
          end
          @output_value = reshaped
        else
          # Oops, input is outside all configured sections.  Unable to shape!
          @output_value = input < minimum ? minimum : input > maximum ? maximum : input
        end
        puts "#{self.class} output_value: #{@output_value}"
      end

      def to_i
        output_value.to_i
      end

      def to_f
        output_value.to_f
      end

      def reshaped
        if cumulative_direction
          case factor_method
          when :* then
            # The product of factors from the sections before or after this section
            (@input_modified_by_cedent_cumulative_base_product || noop_mofidier) +
                # The product of factors from this section before or after the applicable factor
                (@input_modified_by_covered_section_shape || noo_modifier) +
                # The portion of the applicable factor from this section
                (@input_modified_by_section_applicable_factor || noop_modifier)
          else
            raise "Reshaping with factor_method #{factor_method} is not yet implemented"
          end
        else
          raise "Reshaping without a cumulative_direction is not yet implemented"
        end
      end

      def high_end
        last
      end

      def low_end
        first
      end
    end
  end
end
