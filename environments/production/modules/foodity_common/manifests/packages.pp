# Class: foodity_common::packages
#
# This class sets up the aws keys and installs
# all the required packages for a typical foodity environment
#
# Parameters:
#
# Actions:
#   - Configure aws keys
#   - Install common packages
#
# Requires:
#
# Sample Usage:
#
class foodity_common::packages {

  include rvm

  $aws_region = hiera('aws_region')
  $aws_access_key_id = hiera('aws_access_key_id')
  $aws_secret_access_key = hiera('aws_secret_access_key')

  create_resources('@package', hiera_hash('software'))
  Package <||>

  exec { 'rvm-gpg-install':
    path    => '/usr/bin:/usr/sbin:/bin',
    command => 'gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3',
    unless  => 'gpg --list-keys | grep D39DC0E3',
    before  => [Class['rvm'], Exec['system-rvm'] ],
  }


  create_resources('rvm_system_ruby', hiera_hash('rvm_system_rubys'))
  create_resources('rvm_gemset', hiera_hash('rvm_gemsets'))
  create_resources('rvm_gem', hiera_hash('rvm_gems'))

  package { 'docutils':
    ensure  => '0.12',
    provider => 'pip',
  }

  package {'awscli':
    ensure   => present,
    provider => 'pip',
    require  => [File["${::root_home}/.aws"], Package['python-pip'], Package['docutils'] ],
  }

  file {"${::root_home}/.aws":
    ensure  => directory,
    recurse => true,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  file {"${::root_home}/.aws/config":
    ensure   => file,
    owner    => 'root',
    content  => template('foodity_common/aws/config.erb'),
    group    => 'root',
    mode     => '0600',
    require  => "File[${::root_home}/.aws]",
  }

  file {"${::root_home}/dbimports":
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

}
