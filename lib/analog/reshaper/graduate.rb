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
                     :high_end, :low_end, :value_source, :shape_destination,
                     # Next five require index to be set
                     :index, :cedent_section_product,
                     # Next three take arguments
                     :factor_for_input, :portion, :factor_portion
      attr_reader :input_value,
                  :output_value,
                  :shaping_config,
                  :section,
                  :applicable_factor,
                  :percent_of_section_applicable_factor,
                  :input_modified_by_cedent_cumulative_base_product,
                  :input_modified_by_covered_section_shape,
                  :input_modified_by_section_applicable_factor
      def initialize(input:, shaping_config:)
        @input_value = input
        puts "#{self.class} input_value: #{@input_value}"
        @shaping_config = shaping_config
        puts "#{self.class} shaping_config: #{@shaping_config.ai}"
        @section = @shaping_config[@input_value]
        puts "#{self.class} section: #{@section.inspect.green}"
        if @section && factors.any?
          @applicable_factor = factor_for_input(@input_value)
          puts "#{self.class} applicable_factor: #{@applicable_factor}"
          @percent_of_section_applicable_factor = factor_portion(@input_value)
          puts "#{self.class} percent_of_section_applicable_factor: #{@percent_of_section_applicable_factor}"

          # The factor method, e.g. :*, is the manner the various factors are applied to the input_value
          #   cumulative - the product, or sum, of all the antecedent or succedent sections' factors
          #
          # cumulative: product of factors due to :* handling in section config
          # cumulative: sum of factors due to :+ handling in section config
          # in modifying the input value:
          # 1. modify it according to the cumulative, which forms the "cedent_base"
          #   input_value.send(factor_method, cumulative)
          @input_modified_by_cedent_cumulative_base_product = cumulative ? input_value.send(factor_method, cumulative) : 0
          puts "#{self.class} input_modified_by_cedent_cumulative_base_product: #{@input_modified_by_cedent_cumulative_base_product}"

          # 2. modify it according to the product of the relevant section's cedent factors
          #   input_value.send(factor_method, cedent_section_product)
          puts "#{self.class} cedent_section_product: #{cedent_section_product}"
          @input_modified_by_covered_section_shape = cedent_section_product ? input_value.send(factor_method, cedent_section_product) : 0
          puts "#{self.class} input_modified_by_covered_section_shape: #{@input_modified_by_covered_section_shape}"

          # 3. modify it according to the applicable percent of applicable factor
          #   input_value.send(factor_method, percent_of_applicable_factor * applicable_factor)
          @input_modified_by_section_applicable_factor = input_value.send(factor_method, @percent_of_section_applicable_factor * @applicable_factor)
          puts "#{self.class} input_modified_by_section_applicable_factor: #{@input_modified_by_section_applicable_factor}"

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

      def to_h
        {
          input_value: input_value,
          output_value: output_value,
          applicable_factor: applicable_factor,
          percent_of_section_applicable_factor: percent_of_section_applicable_factor,
          input_modified_by_cedent_cumulative_base_product: input_modified_by_cedent_cumulative_base_product,
          input_modified_by_covered_section_shape: input_modified_by_covered_section_shape,
          input_modified_by_section_applicable_factor: input_modified_by_section_applicable_factor,
          shaping_config: {
            maximum: maximum,
            minimum: minimum,
            factor_method: factor_method,
            cumulative_direction: cumulative_direction,
            noop_modifier: noop_modifier
          },
          section: {
            range: range,
            factors: factors,
            cumulative: cumulative,
            distance: distance,
            low_end: low_end,
            high_end: high_end,
            value_source: value_source,
            shape_destination: shape_destination,
            index: index,
            cedent_section_product: cedent_section_product
          }
        }
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
          raise 'Reshaping without a cumulative_direction is not yet implemented'
        end
      end
    end
  end
end
