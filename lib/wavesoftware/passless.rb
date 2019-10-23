require 'digest'

# Main module for Wave Software company
module WaveSoftware
  # Main module fo Passless module
  module PassLess
    require_relative 'passless/generator'
    require_relative 'passless/scope_factory'
    require_relative 'passless/ssldir_resolver'

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
        counter: 1,
        scope: 'alnum',
        length: 16
      }
      compiled = default_options.merge(options)
      compiled = compiled.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
      scope_factory = WaveSoftware::PassLess::ScopeFactory.new
      scope = scope_factory.create(compiled[:scope])
      generator = WaveSoftware::PassLess.generator(method(:ca_crt), method(:ca_key))
      generator.generate(name, scope, compiled[:counter], compiled[:length])
    end

    private

    def self.generator(identityLambda, secretLambda)
      @generator = WaveSoftware::PassLess::Generator.new(identityLambda.call, secretLambda.call) if @generator.nil?
      @generator
    end

    def ca_crt
      crt = ssldir.join('ca', 'ca_crt.pem')
      raise Puppet::Error,
        "Can't access Puppet CA certificate: #{crt}. Passless should be executed on Puppet Server." unless crt.readable?
      Digest::SHA256.hexdigest(crt.read)
    end

    def ca_key
      key = ssldir.join('ca', 'ca_key.pem')
      raise Puppet::Error,
        "Can't access Puppet CA key: #{key}. Passless should be executed on Puppet Server." unless key.readable?
      Digest::SHA256.hexdigest(key.read)
    end

    def ssldir
      WaveSoftware::PassLess::SslDirResolver.resolve
    end
  end
end
