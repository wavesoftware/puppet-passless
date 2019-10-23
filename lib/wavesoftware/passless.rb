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
      compiled = compiled.each_with_object({}) do |(k, v), memo|
        memo[k.to_sym] = v
      end
      scope_factory = WaveSoftware::PassLess::ScopeFactory.new
      scope = scope_factory.create(compiled[:scope])
      generator = WaveSoftware::PassLess.generator(
        method(:identity), method(:secret)
      )
      generator.generate(name, scope, compiled[:counter], compiled[:length])
    end

    class << self
      def generator(identity_lambda, secret_lambda)
        if @generator.nil?
          @generator = WaveSoftware::PassLess::Generator.new(
            identity_lambda.call, secret_lambda.call
          )
        end
        @generator
      end

      def reset
        @generator = nil
      end
    end

    private

    def identity
      scope = closure_scope
      environment = scope['facts']['environment']
      crt = ca_entry('crt', 'certificate')
      crt + environment
    end

    def secret
      ca_entry('key', 'key')
    end

    def ca_entry(type, name)
      entry = ssldir.join('ca', "ca_#{type}.pem")
      error = "Can't access Puppet CA #{name}: #{entry}. "\
              'Passless should be executed on Puppet Server.'
      raise Puppet::ParseError, error unless entry.readable?
      Digest::SHA256.hexdigest(entry.read)
    end

    def ssldir
      WaveSoftware::PassLess::SslDirResolver.resolve
    end
  end
end
