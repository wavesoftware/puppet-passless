require_relative 'array_based'

module WaveSoftware::PassLess::Scope
  class Human < ArrayBased
    def initialize
      # Ref: https://stackoverflow.com/a/55634/844449
      super('!#%+23456789:=?@ABCDEFGHJKLMNPRSTUVWXYZabcdefghijkmnopqrstuvwxyz'.split(''))
    end
  end
end
