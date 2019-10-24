require 'spec_helper_acceptance'

describe :passless do
  let(:pp1) { File.read('examples/passfile.pp') }
  let(:pp2) { File.read('examples/passfile-with-opts.pp') }
  let(:cafixtures) { Pathname.new('spec/fixtures/ca').realpath }

  before do
    run_shell('mkdir -p /etc/puppetlabs/puppet/ssl/ca')

    bolt_upload_file(cafixtures.join('ca_key.pem').to_s,
                     '/etc/puppetlabs/puppet/ssl/ca/ca_key.pem')
    bolt_upload_file(cafixtures.join('ca_crt.pem').to_s,
                     '/etc/puppetlabs/puppet/ssl/ca/ca_crt.pem')
  end

  describe 'executed without any options' do
    it 'results in IOaNTcYttNJRK9Gw password' do
      idempotent_apply(pp1)

      expect(file('/etc/passfile').content).to eq(
        'Password is IOaNTcYttNJRK9Gw'
      )
    end
  end
  describe 'executed with options' do
    it 'results in ysc!%9DY:RVfxchyZNa5KgrkG@L9TB=: password' do
      idempotent_apply(pp2)

      expect(file('/etc/passfile').content).to eq(
        'Password is ysc!%9DY:RVfxchyZNa5KgrkG@L9TB=:'
      )
    end
  end
end
