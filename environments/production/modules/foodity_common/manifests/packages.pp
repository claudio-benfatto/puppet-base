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

  create_resources('package', hiera_hash('software'))

#  package {'rubygems':
#    ensure => present,
#    before => [ 'Package[deep_merge]',
#                'Package[hiera-eyaml]',
#                'Package[highline]'
#              ],
#  }

#  package {'deep_merge':
#    ensure   => 'latest',
#    provider => 'gem',
#  }

#  package {'hiera-eyaml':
#    ensure   => 'latest',
#    provider => 'gem',
#  }

#  package {'highline':
#    ensure   => 'latest',
#    provider => 'gem',
#  }

#  package {'nokogiri':
#    ensure   => '1.5.11',
#    provider => 'gem',
#    require  => [Package['libxslt1-dev'], Package['libxml2-dev']]
#  }

#  package {'aws-sdk':
#    ensure   => present,
#    provider => 'gem',
#    require  => [Package['build-essential'], Package['nokogiri']],
#  }

  rvm_system_ruby {
    'ruby-1.9.3-p547':
      ensure      => 'present',
      default_use => true,
  }

  rvm_gemset {
    'ruby-1.9.3-p547@puppet':
      ensure   => present,
      require  => Rvm_system_ruby['ruby-1.9.3-p547'],
  }

  rvm_gem {
    'ruby-1.9.3-p547@puppet/deep_merge':
      ensure  => '1.0.1',
      require => Rvm_system_ruby['ruby-1.9.3-p547'],
  }

  rvm_gem {
    'ruby-1.9.3-p547@puppet/hiera-eyaml':
      ensure  => '2.0.3',
      require => Rvm_system_ruby['ruby-1.9.3-p547'],
  }

  rvm_gem {
    'ruby-1.9.3-p547@puppet/highline':
      ensure  => '1.6.21',
      require => Rvm_system_ruby['ruby-1.9.3-p547'],
  }

  rvm_gem {
    'ruby-1.9.3-p547@puppet/nokogiri':
      ensure  => '1.6.3.1',
      require => Rvm_system_ruby['ruby-1.9.3-p547'],
  }

  rvm_gem {
    'ruby-1.9.3-p547@puppet/aws-sdk':
      ensure  => '1.52.0',
      require => Rvm_system_ruby['ruby-1.9.3-p547'],
  }


  package {'awscli':
    ensure   => present,
    provider => 'pip',
    require  => [File["${::root_home}/.aws"], Package['python-pip']],
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
