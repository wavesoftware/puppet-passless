desc 'Runs all static checks'
task checks: %i[
  check:symlinks
  check:git_ignore
  check:dot_underscore
  check:test_file
  rubocop
  syntax
  lint
  metadata_lint
]
