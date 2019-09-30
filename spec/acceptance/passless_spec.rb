require 'spec_helper_acceptance'

describe :passless do
  let(:pp) { File.read('examples/passfile.pp') }

  it 'creates a file that contains a password' do
    idempotent_apply(pp)

    expect(file('/etc/passfile')).to contain(
      'Password is 7abb4c65bb1de8f0d2e5a0be2967aedcdae30d1d'
    )
  end
end
