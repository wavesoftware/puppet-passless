require 'spec_helper'
require_relative '../../lib/puppet/functions/passless'
require 'tmpdir'

describe :passless do
  let(:puppetdir) { Pathname.new(Dir.mktmpdir('puppet-passless-')) }
  before(:each) do
    WaveSoftware::PassLess::SslDirResolver.impl(Proc.new { puppetdir })
    ca = puppetdir.join('ca')
    FileUtils.mkdir_p(ca)
    ca.join('ca_crt.pem').write('--BEGIN CERT--')
    ca.join('ca_key.pem').write('--BEGIN KEY--')
  end
  after(:each) do
    FileUtils.remove_entry(puppetdir)
    WaveSoftware::PassLess::SslDirResolver.impl(WaveSoftware::PassLess::SslDirResolver::DEFAULT_PROC)
  end

  it do
    is_expected.to run
      .with_params('passfile-label')
      .and_return('p6uONy0Xs2cnAEt6')
  end

  it do
    is_expected.to run
      .with_params('passfile-label', {'counter' => 1})
      .and_return('p6uONy0Xs2cnAEt6')
  end

  it do
    is_expected.to run
      .with_params('passfile-label', {'counter' => 2})
      .and_return('LtkUaMd4CgbqZuvB')
  end

  it do
    is_expected.to run
      .with_params('passfile-label', {'counter' => 1, 'scope' => 'human', 'length' => 6})
      .and_return("tdG?Po")
  end
end
