require_relative '../../wavesoftware/passless'

Puppet::Functions.create_function(:passless) do
  dispatch :passless do
    required_param 'String', :passname
  end

  def passless(passname)
    WaveSoftware::PassLess.passless(passname)
  end
end
