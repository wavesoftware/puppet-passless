require_relative 'array_based'

module WaveSoftware::PassLess::Scope
  class Alphanumeric < ArrayBased
    def initialize
      super(('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a)
    end
  end
end
