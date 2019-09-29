$pass = passless('passfile-label')
$contents = "Password is ${pass}"

file { '/etc/passfile':
  ensure  => 'file',
  mode    => '0600',
  content => $contents,
}
