$opts = {
  'counter' => 42,
  'scope'   => 'human',
  'length'  => 32,
}
$pass = passless::secret('passfile-label', $opts)
$contents = "Password is ${pass}"

file { '/etc/passfile':
  ensure  => 'file',
  mode    => '0600',
  content => $contents,
}
