# == Class: timkayaws
#
# Full description of class timkayaws here.
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
#  class { timkayaws:
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
class foodity-timkayaws {

  create_resources('file', hiera(aws_files))


#file { '/usr/bin/':
#  owner => 'root',
#  ensure => directory,
#  group => 'root',
#  mode  => 755,
#  recurse => true,
#  source  => 'puppet:///modules/foodity-timkayaws/aws',
#}

#file { '/home/ubuntu/.awssecret':
#  owner => 'ubuntu',
#  group => 'ubuntu',
#  mode  => 400,
#  content => hiera(aws_secret),
#}

#file { '/home/vagrant/.awsrc':
#  owner => 'ubuntu',
#  group => 'ubuntu',
#  mode  => 400,
#  content => hiera(aws_src)
#}


}
