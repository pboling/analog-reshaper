require 'analog/reshaper/version'

# External gems
require 'memoist'
require 'hashie'
require 'awesome_print'
require 'colorize'

# This gem
# NOTE: uses code that was inspired by the very broken 'analog' gem
# The released analog gem is actually in the Scale namespace,
#   and that functionality is re-homed, re-written, and fixed, to the
#   Analog namespace here.  This means this gem does not rely on, nor conflict
#   with the released 'analog' gem.
require 'analog/destination'
require 'analog/scheme'
require 'analog/source'
require 'analog/reshaper/graduate'
require 'analog/reshaper/shaping_configuration'
require 'analog/reshaper/section_configuration'

module Analog
  module Reshaper
    def reshape(value, reshape_config)
      Analog::Reshaper::Graduate.new(
          input: value,
          shaping_config: reshape_config
      ).output
    end
    module_function :reshape
  end
end
