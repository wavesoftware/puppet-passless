require 'openssl'

module WaveSoftware::PassLess::Crypt
  # Class implements PBKDF2 key derivation function
  class Pbkdf2
    def initialize(salt, cost, blocksize, parallelization, length)
      @salt = salt
      @cost = cost
      @parallelization = parallelization
      @blocksize = blocksize
      @length = length
    end

    # Syntactic sugar for the underlying mathematical definition of PBKDF2.
    #
    # Returns: Binary representation of the derived key (DK).
    def crypt(password)
      digest = OpenSSL::Digest.new('sha512')
      cost = Integer(@cost) * Integer(@parallelization)
      hex(pbkdf2(digest, password, @salt, cost, @length))
    end

    private

    def randomize(digest, password, seed)
      OpenSSL::HMAC.digest(digest, password, seed)
    end

    # Binary to hex convenience method.
    def hex(str)
      str.unpack('H*').first
    end

    # The PBKDF2 key derivation function has five input parameters:
    #
    #     DK = PBKDF2(PRF, Password, Salt, c, dkLen)
    #
    # where:
    #
    # - PRF is a pseudorandom function of two parameters
    # - Password is the master password from which a derived key is generated
    # - Salt is a cryptographic salt
    # - c is the number of iterations desired
    # - dkLen is the desired length of the derived key
    #
    #   DK is the generated derived key.
    #
    def pbkdf2(digest, password, salt, c, dk_len)
      blocks_needed = (dk_len.to_f / digest.size).ceil

      result = ''

      # main block-calculating loop:
      1.upto(blocks_needed) do |n|
        result << concatenate(digest, password, salt, c, n)
      end

      # truncate to desired length:
      result.slice(0, dk_len)
    end

    # The function F is the xor (^) of c iterations of chained PRFs.
    # The first iteration of PRF uses Password as the PRF key and Salt
    # concatenated to i encoded as a big-endian 32-bit integer.
    #
    # Note that i is a 1-based index. Subsequent iterations of PRF use
    # Password as the PRF key and the output of the previous PRF
    # computation as the salt:
    #
    # Definition:
    #
    #     F(Password, Salt, Iterations, i) = U1 ^ U2 ^ ... ^ Uc
    #
    def concatenate(digest, password, salt, iterations, i)
      # U1 -> password, salt and 1 encoded as big-endian 32-bit integer.
      u = randomize(digest, password, salt + [i].pack('N'))

      ret = u

      # U2 through Uc:
      2.upto(iterations) do
        # calculate Un
        u = randomize(digest, password, u)

        # xor it with the previous results
        ret = xor(ret, u)
      end

      ret
    end

    # Time-attack safe comparison operator.
    #
    # @see http://bit.ly/WHHHz1
    def compare(a, b)
      return false unless a.length == b.length

      cmp = b.bytes.to_a
      result = 0

      a.bytes.each_with_index do |char, index|
        result |= char ^ cmp[index]
      end

      result.zero?
    end

    def xor(a, b)
      result = ''.encode('ASCII-8BIT')

      b_bytes = b.bytes.to_a

      a.bytes.each_with_index do |c, i|
        result << (c ^ b_bytes[i])
      end

      result
    end
  end
end
