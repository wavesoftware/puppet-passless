require_relative '../../../wavesoftware/passless'

Puppet::Functions.create_function(:'passless::secret') do
  dispatch :passless do
    required_param 'String', :passname
    optional_param 'Passless::Opts', :options
    return_type 'String'
  end

  include WaveSoftware::PassLess
end
