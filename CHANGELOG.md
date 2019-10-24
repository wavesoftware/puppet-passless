# Changelog

All notable changes to this project will be documented in this file.

## Release 0.1.0

**Features**

 * Working implementation of master password algorithm
 * PBKDF2 key derivation function
 * Unit (rspec-puppet) and acceptance tests (litmus)

**Known Issues**

 * Hiera integration isn't completed yet 
   (https://github.com/wavesoftware/puppet-passless/issues/1)
 * SCrypt should be used, instead of PBKDF2 if available, as well as it's 
   installation (https://github.com/wavesoftware/puppet-passless/issues/3)
