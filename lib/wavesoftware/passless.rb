require 'digest'

# Main module for Wave Software company
module WaveSoftware
  # Main module fo Passless module
  module PassLess
    # Passless function that is used to generate passwords
    #
    # == Parameters:
    # name::
    #   A name of a password to generate.
    # options::
    #   An optional parameters. Keys might be `num`, `scope`, or `length`.
    #
    # == Returns:
    # A string with a generated password inside.
    def passless(name, options = {})
      default_options = {
        num: 1,
        scope: 'alnum',
        length: 16
      }
      compiled = default_options.merge(options)
      compiled = compiled.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
      validate_options(compiled)
      ca_key = WaveSoftware::PassLess.key_fingerprint
      ca_crt = WaveSoftware::PassLess.crt
      Digest::SHA1.hexdigest(name)
    end

    private

    def validate_options(options)
      raise Puppet::Error, 'num options must be numeric' unless options[:num].is_a? Numeric
      raise Puppet::Error, 'length options must be numeric' unless options[:length].is_a? Numeric
      valid_scopes = [:num, :alpha, :alnum, :human, :keys, :utf8]
      unless options[:scope].to_sym in valid_scopes
        options[:scope]
        raise Puppet::Error,
          'scope must be either one of "num", "alpha", "alnum", "human", "keys", "utf8", or "list:" with defined chars afterwards.' unless options[:scope].starts_with? 'list:'
      end
    end

    def self.crt
      if @@crt.nil?
        ssldir = Pathname.new(Puppet.settings[:ssldir])
        ca_crt = ssldir.join('ca', 'ca_crt.pem')
        @@crt = ca_crt.read
      end
      @@crt
    end

    def self.key_fingerprint
      if @@key_fingerprint.nil?
        ssldir = Pathname.new(Puppet.settings[:ssldir])
        ca_key = ssldir.join('ca', 'ca_key.pem')
        @@key_fingerprint = Digest::SHA256.hexdigest(ca_key.read)
      end
      @@key_fingerprint
    end

    @@key_fingerprint = nil
    @@crt = nil
  end
end
