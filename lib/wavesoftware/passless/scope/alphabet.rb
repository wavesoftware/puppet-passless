require_relative 'array_based'

module WaveSoftware::PassLess::Scope
  class Alphabet < ArrayBased
    def initialize
      super(('a'..'z').to_a + ('A'..'Z').to_a)
    end
  end
end
