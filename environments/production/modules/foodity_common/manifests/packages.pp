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

  create_resources('rvm_system_ruby', hiera_hash('rvm_system_rubys'))
  create_resources('rvm_gemset', hiera_hash('rvm_gemsets'))
  create_resources('rvm_gem', hiera_hash('rvm_gems'))

#  case $::operatingsystem {
#    'Ubuntu': {
#
#               if $::operatingsystemrelease =~ /^14/ {
#                 $rubygems_package_name = 'rubygems-integration'
#               }
#    }
#    
#   default: {
#          $rubygems_package_name = 'rubygems'
#        }
#   }


#  package { 'rubygems':
#    name    => $rubygems_package_name ,
#    ensure  => 'present',
#    before  => [ 'Package[deep_merge]', 'Package[hiera-eyaml]', 'Package[highline]' ],
#  }


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
