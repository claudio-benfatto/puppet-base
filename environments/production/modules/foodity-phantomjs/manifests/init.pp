# == Class: phantomjs
#
# Full description of class phantomjs here.
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
#  class { phantomjs:
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
class foodity-phantomjs {

  foodity-tarball { 'phantomjs-1.6.1':
    module_name => 'foodity-phantomjs',
    install_dir => '/usr/local',
    pkg_tgz => 'phantomjs-1.6.1-linux-x86_64-dynamic.tar.bz2',
    before => File['/usr/local/bin/phantomjs'],
  } 

  file { '/usr/local/bin/phantomjs':
    ensure => 'link',
    target => "/usr/local/phantomjs-1.6.1-linux-x86_64-dynamic/bin/phantomjs",
  }

}
