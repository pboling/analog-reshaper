require 'analog/destination/enumerable'
require 'analog/destination/range'

module Analog
  # These are the classes that describe what range the transformed number
  # will wind up in. They're named after the core Ruby class that the input closest
  # resembles.
  module Destination
    # Map Ruby classes/modules to scaling destination classes/modules
    MAP = {
      ::Enumerable => Destination::Enumerable,
      ::Range => Destination::Range
    }.freeze

    # Build the appropriate scaling destination class for the given Ruby object
    # @param [::Enumerable] destination
    # @return [Analog::Destination::Enumerable, Analog::Destination::Range]
    def self.new(destination)
      klass = MAP[destination.class]
      if klass.nil?
        klasses = MAP.select { |k, _v| destination.is_a?(k) }
        klass = klasses.values.first
      end
      klass.new(destination) unless klass.nil?
    end
  end
end
