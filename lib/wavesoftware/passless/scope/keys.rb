require_relative 'array_based'

module WaveSoftware::PassLess::Scope
  class Keys < ArrayBased
    def initialize
      super(('!'..'}').to_a)
    end
  end
end
