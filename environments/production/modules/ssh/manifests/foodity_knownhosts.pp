# == Class: ssh
#
# Full description of class ssh here.
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
#  class { ssh:
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
class ssh::foodity_knownhosts( $username='root', $server_list ) {
   $group = $username
 
    file{ '/tmp/known_hosts.sh' :
      ensure => present,
      mode => 0500,
      content => template('ssh/known_hosts.sh.erb'),
    }
 
    exec{ 'add_known_hosts' :
      command => "/tmp/known_hosts.sh",
      path => "/sbin:/usr/bin:/usr/local/bin/:/bin/",
      provider => shell,
      user => 'root',
      require => File["${::ssh::params::ssh_known_hosts}", '/tmp/known_hosts.sh' ]
    }
}
