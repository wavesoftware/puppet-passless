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
to Puppet environemnt.

```puppet
class { 'postgresql::server':
  postgres_password => passless('postgresql::server)',
}
```

Each password generation can be influenced by providing a options. Those options are:

 * `num` - A sequential password number. Changing the password should be done by 
   advancing this number. Thare is also a global sequence number that can be changed.
 * `space` - A definition of space that the password will be generated from. It may
   be a list of chars.

## Usage

Include usage examples for common use cases in the **Usage** section. Show your users how to use your module to solve problems, and be sure to include code examples. Include three to five examples of the most important or common tasks a user can accomplish with your module. Show users how to accomplish more complex tasks that involve different types, classes, and functions working in tandem.

## Development

In the Development section, tell other users the ground rules for contributing to your project and how they should submit their work.

## Release Notes/Contributors/Etc. **Optional**

If you aren't using changelog, put your release notes here (though you should consider using changelog). You can also add any additional sections you feel are necessary or important to include here. Please use the `## ` header.
