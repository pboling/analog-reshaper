require 'analog/source/enumerable'
require 'analog/source/range'

module Analog
  # These are the classes that describe what range the transformed number
  # starts in.  They're named after the core Ruby class that the input closest
  # resembles.
  module Source
    # Map Ruby classes/modules to scaling source classes/modules
    MAP = {
      ::Enumerable => Source::Enumerable,
      ::Range => Source::Range
    }.freeze

    # Build the appropriate scaling source class for the given Ruby object
    # @param [::Enumerable] source
    # @return [Analog::Source::Enumerable, Analog::Source::Range]
    def self.new(source)
      klass = MAP[source.class]
      if klass.nil?
        klasses = MAP.select { |k, _v| source.is_a?(k) }
        klass = klasses.values.first
      end
      klass.new(source) unless klass.nil?
    end
  end
end
