require 'spec_helper'
require_relative '../../lib/puppet/functions/passless'
require 'tmpdir'

describe :passless do
  let(:puppetdir) { Pathname.new(Dir.mktmpdir('puppet-passless-')) }

  before do
    WaveSoftware::PassLess::SslDirResolver.impl(proc { puppetdir })
    ca = puppetdir.join('ca')
    FileUtils.mkdir_p(ca)
    WaveSoftware::PassLess.reset
  end
  after do
    WaveSoftware::PassLess::SslDirResolver.impl(
      WaveSoftware::PassLess::SslDirResolver::DEFAULT_PROC
    )
    FileUtils.rm_rf(puppetdir)
  end

  describe 'with proper Puppet CA' do
    before do
      ca = puppetdir.join('ca')
      ca.join('ca_crt.pem').write('--BEGIN CERT--')
      ca.join('ca_key.pem').write('--BEGIN KEY--')
    end

    describe 'with environemnt "stage"' do
      let(:environment) { 'stage' }

      it do
        is_expected.to run
          .with_params('passfile-label')
          .and_return('zWABIfQVdYcVZM5y')
      end

      it do
        is_expected.to run
          .with_params('passfile-label', 'counter' => 1)
          .and_return('zWABIfQVdYcVZM5y')
      end

      it do
        is_expected.to run
          .with_params('passfile-label', 'counter' => 2, 'scope' => 'alnum')
          .and_return('6COKhRHmt3QuwqTj')
      end

      it do
        is_expected.to run
          .with_params('passfile-label',
                       'counter' => 1, 'scope' => 'human', 'length' => 6)
          .and_return('Hmbeua')
      end

      it do
        is_expected.to run
          .with_params('passfile-label',
                       'counter' => 1, 'scope' => 'invalid', 'length' => 6)
          .and_raise_error(Puppet::ParseError,
                           'Scope must be either one of "num", "alpha", '\
                           '"alnum", "human", "keys", "utf8", or "list:" '\
                           'with defined chars afterwards. "invalid" was '\
                           'given.')
      end

      it do
        is_expected.to run
          .with_params('passfile-label',
                       'counter' => 5, 'scope' => 'utf8', 'length' => 8)
          .and_return('⥸P×࿘ؠ➜⣧त')
      end

      it do
        is_expected.to run
          .with_params('passfile-label',
                       'counter' => 42, 'scope' => 'keys', 'length' => 8)
          .and_return('F66:8?V]')
      end

      it do
        is_expected.to run
          .with_params(
            'passfile-label',
            'counter' => 42, 'scope' => 'list:abcd1234', 'length' => 8
          )
          .and_return('a4cb4332')
      end

      it do
        is_expected.to run
          .with_params('passfile-label',
                       'counter' => 42, 'scope' => 'num', 'length' => 4)
          .and_return('4747')
      end
    end

    describe 'with environemnt "qa"' do
      let(:environment) { 'qa' }

      it do
        is_expected.to run
          .with_params('passfile-label')
          .and_return('Njj5q6icBNNT7QaS')
      end

      it do
        is_expected.to run
          .with_params('passfile-label',
                       'counter' => 42, 'scope' => 'alpha', 'length' => 32)
          .and_return('WPHVGHcgglSKmdLnchkSrekcMKVrpqyq')
      end
    end
  end

  describe 'without Puppet CA, like using puppet apply' do
    it do
      is_expected.to run
        .with_params('passfile-label')
        .and_raise_error(Puppet::ParseError,
                         /Can't access Puppet CA certificate/)
    end
  end
end
