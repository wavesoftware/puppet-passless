require_relative 'array_based'

module WaveSoftware::PassLess::Scope
  class List < ArrayBased
    def initialize(elements)
      super(elements)
    end
  end
end
