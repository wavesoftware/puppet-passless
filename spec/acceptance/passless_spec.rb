require 'spec_helper_acceptance'

describe :passless do
  let(:pp) { example '::passless::passfile' }

  it 'creates a file that contains a password' do
    idempotent_apply(pp)
    
    expect(file('/etc/passfile')).to contain('Password is qaz123')
  end

end
