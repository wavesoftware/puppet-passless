require 'spec_helper_acceptance'

describe :passless do
  let(:pp) { File.read('examples/passfile.pp') }
  let(:cafixtures) { Pathname.new('spec/fixtures/ca').realpath }

  before do
    run_shell('mkdir -p /etc/puppetlabs/puppet/ssl/ca')
    
    bolt_upload_file(cafixtures.join('ca_key.pem').to_s,
      '/etc/puppetlabs/puppet/ssl/ca/ca_key.pem')
    bolt_upload_file(cafixtures.join('ca_crt.pem').to_s,
      '/etc/puppetlabs/puppet/ssl/ca/ca_crt.pem')
  end

  it 'creates a file that contains a password' do
    idempotent_apply(pp)

    expect(file('/etc/passfile')).to contain(
      'Password is kgxAl7U4nDE63t91'
    )
  end
end
