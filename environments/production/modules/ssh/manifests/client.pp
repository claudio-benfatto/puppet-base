class ssh::client(
  $ensure               = present,
  $options              = {}
) inherits ssh::params {
  $merged_options = merge($ssh::params::ssh_default_options, $options)

  include ssh::client::install
  include ssh::client::config
  include ssh::foodity_knownhosts

  anchor { 'ssh::client::start': }
  anchor { 'ssh::client::end': }

  Anchor['ssh::client::start'] ->
  Class['ssh::client::install'] ->
  Class['ssh::client::config'] ->
  Class['ssh::foodity_knownhosts'] ->
  Anchor['ssh::client::end']
}
