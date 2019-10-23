require_relative 'array_based'

module WaveSoftware::PassLess::Scope
  class Numeric < ArrayBased
    def initialize
      super(('0'..'9').to_a)
    end
  end
end
