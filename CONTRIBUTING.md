This module has grown over time based on a range of contributions from
people using it. If you follow these contributing guidelines your patch
will likely make it into a release a little quicker.


## Contributing

1. Fork the repo.
1. Create your feature branch (`git checkout -b feature/my-new-feature`)
1. Run the tests. We only take pull requests with passing tests, and
   it's great to know that you have a clean slate
1. Add a test for your change. Only refactoring and documentation
   changes require no new tests. If you are adding functionality
   or fixing a bug, please add a test.
1. Make the test pass.
1. Push to your fork and submit a pull request.


## Dependencies

The testing and development tools have a bunch of dependencies,
all managed by [bundler](http://bundler.io/).

By default the tests use a baseline version of Puppet.

Install the dependencies like so:

```bash
bundle
```

## Syntax and style

The test suite will run [Puppet Lint](http://puppet-lint.com/), and
[Puppet Syntax](https://github.com/gds-operations/puppet-syntax), as 
well [Rubocop](https://github.com/rubocop-hq/rubocop) to check various
syntax and style things. You can run these locally with:

```bash
bundle exec rake checks
```

## Running the unit tests

The unit test suite covers most of the code, as mentioned above please
add tests if you're adding new functionality. If you've not used
[rspec-puppet](http://rspec-puppet.com/) before then feel free to ask
about how best to test your new feature. Running the test suite is done
with:

```bash
bundle exec rake spec
```

Or for parallel testing

```bash
bundle exec rake parallel_spec
```

## Integration tests

The unit tests just check the code runs, not that it does exactly what
we want on a real machine. For that we're using
[litmus](https://github.com/puppetlabs/puppet_litmus).

This fires up a new container and runs a series of simple tests against
it after applying the module. You can run this with:

```bash
ruby .ci/acceptance.rb
```

This will run the tests on an default containers. You can also run the 
integration tests against any other configuration specified in file 
`provision.yaml`. For example for Ubuntu 18.04 you should run:

```
LITMUS_KEY=waffle_deb ruby .ci/acceptance.rb
```
