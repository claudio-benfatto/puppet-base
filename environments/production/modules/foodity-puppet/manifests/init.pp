# == Class: puppet
#
# Full description of class puppet here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { puppet:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2014 Your name here, unless otherwise noted.
#
class foodity-puppet {


  file { '/usr/local/bin/papply':
    source => 'puppet:///modules/foodity-puppet/papply.sh',
    mode => '0755',
  }

  file { '/usr/local/bin/pull-updates':
    source => 'puppet:///modules/foodity-puppet/pull-updates.sh',
    mode => '0755',
}


  create_resources('file', hiera_hash(private_ssh_key))

#  file { '/root/.ssh/id_rsa':
#    owner => 'root',
#    mode  => '0600',
#  }

   cron { 'run-puppet':
     ensure => 'present',
     user => 'root',
     command => '/usr/local/bin/pull-updates',
     minute => '*/10',
     hour => '*',
  }

}
