require 'analog/reshaper/version'

# External gems
# require 'scale' # the filename of the main file of the analog gem
require 'memoist'
require 'hashie'

# This gem
require 'analog/reshaper/graduate'
require 'analog/reshaper/shaping_configuration'
require 'analog/reshaper/section_configuration'

module Analog
  module Reshaper
    def reshape(reshape_config)
      # input must come from the object this module is mixed into.
      @input = Analog::Reshaper::Graduate.new(
          input: input,
          shaping_config: reshape_config
      ).output
      self
    end
  end

  def reshape(value, reshape_config)
    Analog::Reshaper::Graduate.new(
        input: value,
        shaping_config: reshape_config
    ).output
  end
end

# Mix Analog::Reshaper into analog gem as follows:
# Scale::Scheme.send(:include, Analog::Reshaper)
