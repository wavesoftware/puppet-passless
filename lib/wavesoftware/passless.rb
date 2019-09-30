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
    #
    # == Returns:
    # A string with a generated password inside.
    def passless(name)
      Digest::SHA1.hexdigest(name)
    end
  end
end
