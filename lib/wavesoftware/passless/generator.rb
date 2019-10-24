require_relative 'crypt/pbkdf2'
require 'zlib'

module WaveSoftware::PassLess
  INTEGER_MAX = 256 * 256
  module Type
    AUTHENTICATION = 'pl.wavesoftware.masterpassword'.freeze
  end

  # Masterpassword algothitm implementation, without password templates
  #
  # Ref: http://www.masterpasswordapp.com/masterpassword-algorithm.pdf
  class Generator
    def initialize(identity, secret)
      @master_key ||= begin
        calculate_master_key(identity, secret)
      end
    end

    def generate(name, scope, counter, length)
      skey = calculate_site_key(name, @master_key, counter)
      calculate_password(skey, scope, length)
    end

    private

    def calculate_master_key(identity, secret)
      key             = secret
      salt            = Type::AUTHENTICATION + identity.length.to_s + identity
      cost            = 32_768
      blocksize       = 8
      parallelization = 2
      length          = 64

      crypt(key, salt, cost, blocksize, parallelization, length)
    end

    def calculate_site_key(site_name, master_key, counter)
      key  = master_key
      seed = Type::AUTHENTICATION + site_name.length.to_s +
        site_name + counter.to_s
      digest = OpenSSL::Digest.new('sha256')
      OpenSSL::HMAC.digest(digest, key, seed)
    end

    def calculate_password(site_key, scope, length)
      password = ''
      numbers = number_generator(site_key)
      while password.length < length
        number = numbers.next
        password << scope.provide(number)
      end
      raise 'Generated password has invalid size' if password.length != length
      password
    end

    def number_generator(site_key)
      Enumerator.new do |yielder|
        bytes = site_key
        random = Random.new(Zlib.crc32(site_key))
        loop do
          begin
            if !bytes.empty?
              next_dbyte = bytes[0..1]
              bytes = bytes[2..-1]
              yielder << ("\x00\x00" + next_dbyte).unpack('N').first
            else
              yielder << random.rand(INTEGER_MAX)
            end
          rescue RangeError => ex
            Puppet.debug("Unexpected: #{ex}")
          end
        end
      end
    end

    def crypt(key, salt, cost, blocksize, parallelization, length)
      # TODO: Call scrypt if available
      algorithm = WaveSoftware::PassLess::Crypt::Pbkdf2.new(
        salt, cost, blocksize, parallelization, length
      )
      algorithm.crypt(key)
    end
  end
end
