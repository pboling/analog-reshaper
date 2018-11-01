require 'analog/reshaper/version'

# External gems
require 'scale' # the filename of the main file of the analog gem
require 'memoist'
require 'hashie'

# This gem
require 'analog/reshaper/graduate'
require 'analog/reshaper/shaping_configuration'
require 'analog/reshaper/section_configuration'
require 'analog/reshaper/preceding_mod/enumerable'
require 'analog/reshaper/preceding_mod/range'

# Overrides of analog gem
require 'analog/reshaper/ext/scale/destination/enumerable'
require 'analog/reshaper/ext/scale/destination/range'
require 'analog/reshaper/ext/scale/scheme'

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

