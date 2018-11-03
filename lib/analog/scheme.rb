module Analog
  # Build a scaling scheme for the given input
  # @param [Numeric] input
  # @return [Analog::Scheme]
  def transform(input)
    Scheme.new.scale(input)
  end
  alias scale transform
  module_function :transform, :scale

  # Build a scaling scheme starting with the given source
  # @param [::Enumerable] source
  # @return [Analog::Scheme]
  def from(source)
    Scheme.new.from(source)
  end
  module_function :from

  # Build a scaling scheme starting with the given destination
  # @param [::Enumerable] destination
  # @return [Analog::Scheme]
  def to(destination)
    Scheme.new.to(destination)
  end
  module_function :to

  # Build a scaling scheme starting with the given source and destination
  # @param [::Enumerable] source
  # @param [::Enumerable] destination
  # @return [Analog::Scheme]
  def using(source, destination)
    Scheme.new.using(source, destination)
  end
  module_function :using

  # Describes a particular scaling scenario
  class Scheme
    attr_reader :destination, :input, :source

    # @param [Hash] options
    # @option options [::Enumerable] :destination The destination for this scaling scenario
    # @option options [::Enumerable] :source The source for this scaling scenario
    def initialize(options = {})
      @input = options[:input]
      @destination = nil
      @source = nil

      @source = Source.new(options[:source]) unless options[:source].nil?
      unless options[:destination].nil?
        @destination = Destination.new(options[:destination])
      end
    end

    # Set the source for this scaling scenario.  If on calling this method, the scenario
    # has all of its needed properties, the scaled value will be returned.  Otherwise
    # this method will return the updated Scheme object.
    #
    # @param [::Enumerable] source
    # @return [Numeric, Analog::Scheme]
    def from(source)
      @source = Source.new(source)
      scale? ? result : self
    end

    # Set the destination for this scaling scenario.  If on calling this method, the
    # scenario has all of its needed properties, the scaled value will be returned.
    # Otherwise this method will return the updated Scheme object.
    #
    # @param [::Enumerable] destination
    # @return [Numeric, Analog::Scheme]
    def to(destination)
      @destination = Destination.new(destination)
      scale? ? result : self
    end

    # Set both the source and destination on this scheme. If on calling this method, the
    # scenario has all of its needed properties, the scaled value will be returned.
    # Otherwise this method will return the updated Scheme object.
    #
    # @param [::Enumerable] source
    # @param [::Enumerable] destination
    # @return [Numeric, Analog::Scheme]
    def using(source, destination)
      @source = Source.new(source)
      @destination = Destination.new(destination)
      scale? ? result : self
    end

    # Set the input of this scaling scenario.  If on calling this method, the
    # scenario has all of its needed properties, the scaled value will be returned.
    # Otherwise this method will return the updated Scheme object.
    #
    # @param [Numeric] number
    # @return [Numeric, Analog::Scheme]
    def scale(number)
      @input = number
      scale? ? result : self
    end
    alias transform scale

    # Build a reshaping scheme with the given config
    # @param [Hash] reshape_config
    # @return [Analog::Scheme]
    def reshape(reshape_config)
      @input = Analog::Reshaper.reshape(@input, reshape_config)
      self
    end

    # Scan this scaling scenario be run?
    # @return [Boolean] Whether this scaling scenario can be run
    def scale?
      !@input.nil? && !@source.nil? && !@destination.nil?
    end

    # Get the result of this scaling scenario
    # @return [Numeric, nil]
    def result
      @result ||= @destination.scale(@input, @source)
    end
  end
end
