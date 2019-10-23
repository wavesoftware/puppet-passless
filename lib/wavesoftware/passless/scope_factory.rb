require_relative 'scope_type'
require_relative 'scope/alphabet'
require_relative 'scope/alphanumeric'
require_relative 'scope/numeric'
require_relative 'scope/human'
require_relative 'scope/keys'
require_relative 'scope/utf8'
require_relative 'scope/list'

module WaveSoftware::PassLess
  class ScopeFactory
    PARAMETERLESS = {
      ScopeType::ALPHABET     => WaveSoftware::PassLess::Scope::Alphabet.new,
      ScopeType::ALPHANUMERIC => WaveSoftware::PassLess::Scope::Alphanumeric.new,
      ScopeType::NUMERIC      => WaveSoftware::PassLess::Scope::Numeric.new,
      ScopeType::HUMAN        => WaveSoftware::PassLess::Scope::Human.new,
      ScopeType::KEYS         => WaveSoftware::PassLess::Scope::Keys.new,
      ScopeType::UTF8         => WaveSoftware::PassLess::Scope::Utf8.new(2)
    }.freeze
    LIST_PREFIX = 'list:'.freeze

    def create(repr)
      sym = repr.to_sym
      return PARAMETERLESS[sym] if PARAMETERLESS.keys.include?(sym)
      if repr.start_with?(LIST_PREFIX)
        scope = repr[LIST_PREFIX.length..-1].split('').uniq
        return WaveSoftware::PassLess::Scope::List.new(scope)
      end
      raise Puppet::ParseError,
            'Scope must be either one of "num", "alpha", "alnum", "human", '\
            '"keys", "utf8", or "list:" with defined chars afterwards. '\
            "\"#{repr}\" was given."
    end
  end
end
