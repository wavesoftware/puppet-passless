module WaveSoftware::PassLess::Scope
  class ArrayBased
    def initialize(array)
      @array = array
    end
    
    def provide(number)
      @array[number % @array.length]
    end
  end
end
