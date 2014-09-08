# == Class: common
#
# Full description of class common here.
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
#  class { common:
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
class foodity_common {

  contain foodity_common::packages

  user { 'ubuntu':
      name       => 'ubuntu',
      ensure     => 'present',
      home       => '/home/ubuntu',
      managehome => true,
      shell      => '/bin/sh',
  }

  file { '/home/ubuntu/.ssh':
       ensure    => 'directory',
       mode      => '0755',
       owner     => 'ubuntu',
       require   => User['ubuntu'],
  }

  create_resources('ssh_authorized_key' , hiera(ssh_authorized_keys))

}
