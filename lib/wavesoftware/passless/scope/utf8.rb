#encoding: utf-8

module WaveSoftware::PassLess::Scope
  class Utf8
    def initialize(mb = 3)
      @generator = lazy_printable_random_utf8(mb)
    end

    def provide(number)
      @random = Random.new(number)
      @generator.next
    end

    private

    def lazy_printable_random_utf8(mb)
      return enum_for(__callee__, mb).lazy unless block_given?
    
      # determine the maximum codepoint based on the number of UTF-8 bytes
      max = [0x80, 0x800, 0x10000, 0x110000][mb.pred]
    
      loop do
        char = @random.rand(max).chr('UTF-8')
    
        yield char if char.match?(/[[:print:]]/)
      rescue RangeError
      end
    end
  end
end
