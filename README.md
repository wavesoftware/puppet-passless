Passless for Puppet
===================

It's a Puppet master password implementation that uses Puppet server's CA to automate 
password creation.

#### Table of Contents

1. [Description](#description)
3. [Usage - Configuration options and additional functionality](#usage)
5. [Development - Guide for contributing to the module](#development)

## Description

This module contains a a function `passless` that will generate a password based on a 
name given. Each password will be generated using a master password algorithm. This 
algorithm will take a Puppet CA as a master password. Password generated will be unique
to Puppet environment.

```puppet
class { 'postgresql::server':
  postgres_password => passless('postgresql::server'),
}
```

## Usage

A `passless` function takes a minimum of one argument. That argument is name of password to be generated. 

Each password generation can be influenced by providing a options. Options are given on hashmap called `options`. Those options are:

 * `counter` - A sequential password number. Changing the password should be done by 
   advancing this number. Default value is `1`.
 * `scope` - A definition of scope that the password will be generated from. It may
   be one of (defaults to `alnum`): 
    * `num` for numeric passwords,
    * `alpha` for alphabet based passwords, both big and small caps,
    * `alnum` for alphanumeric passwords, both big and small caps,
    * `human` for letters and numbers that are easy to distinguish by human,
    * `keys` for passwords that can be typed by keyboard, so letters, and numbers, and special characters,
    * `utf8` these passwords contain utf-8 characters, so also a characters that aren't easy to type by keyboard,
    * `list:` followed by list of chars that might be used. Ex.: `list:abcdef1234567890!$`,
 * `length` - A length of password to be generated in number of signs. Default value is `16`.

```puppet
$options = {
  'counter' => 5,
  'scope'   => 'human',
  'length'  => 24,
}
user { 'root':
  password => passless("root@${::fqdn}", $options),
}
```

### Hiera

**Hiera integration isn't done yet (#1)**

All options described above can also be set via Hiera. To do this define a key that is 
created by adding a password name and suffix of `::counter`, `::scope`, or `::length`. Ex.:

```yaml
root@puppet.example.org::counter: 13
root@puppet.example.org::scope: alnum
root@puppet.example.org::length: 32
```

You can specify a `counter` both in Puppet code and in Hiera. Specifying `scope` or `length`,
in both places isn't supported and will result in compilation error.

## Development

Development is described in separate document [CONTRIBUTING.md](CONTRIBUTING.md).

## Release Notes

See [CHANGELOG.md](CHANGELOG.md) for project release notes.
