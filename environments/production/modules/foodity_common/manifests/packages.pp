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


#  package {'rubygems':
#    ensure => present,
#    before => [ 'Package[deep_merge]',
#                'Package[hiera-eyaml]',
#                'Package[highline]'
#              ],
#  }

#  package {'deep_merge':
#    ensure   => '1.0.1',
#    provider => 'gem',
#  }

#  package {'hiera-eyaml':
#    ensure   => '2.0.3',
#    provider => 'gem',
#  }

#  package {'highline':
#	    ensure   => '1.6.21',
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

#  rvm_system_ruby {
#    'ruby-1.9.3-p547':
#      ensure      => 'present',
#      default_use => true,
#  }

#  rvm_gemset {
#    'ruby-1.9.3-p547@puppet':
#      ensure   => present,
#      require  => Rvm_system_ruby['ruby-1.9.3-p547'],
#  }


  create_resources('rvm_system_ruby', hiera_hash('rvm_system_rubys'))
  create_resources('rvm_gemset', hiera_hash('rvm_gemsets'))
  create_resources('rvm_gem', hiera_hash('rvm_gems'))

  $rubygems_package_name = 'rubygems'

  notify { "OPERATING SYSTEM $::operatingsystem and OPERATION RELEASE $::operatingsystemrelease": }

  case $::operatingsystem {
    'Ubuntu': {

                notify { "OK UBUNTU": }
               if $::operatingsystemrelease =~ /^14/ {
                 notify { "OK UBUNTU AND 14.4": }
                 $rubygems_package_name = 'rubygems-integration'
               }
    }
    
   default: {
          $rubygems_package_name = 'rubygems'
        }
   }


  package {'rubygems':
    name    => $rubygems_package_name ,
    ensure  => 'present',
    before  => [ 'Package[deep_merge]', 'Package[hiera-eyaml]', 'Package[highline]' ],
  }



#  rvm_gem {
#    'ruby-1.9.3-p547@puppet/deep_merge':
#      ensure  => '1.0.1',
#      require => Rvm_system_ruby['ruby-1.9.3-p547'],
#  }

#  rvm_gem {
#    'ruby-1.9.3-p547@puppet/hiera-eyaml':
#      ensure  => '2.0.3',
#      require => Rvm_system_ruby['ruby-1.9.3-p547'],
#  }

#  rvm_gem {
#    'ruby-1.9.3-p547@puppet/highline':
#      ensure  => '1.6.21',
#      require => Rvm_system_ruby['ruby-1.9.3-p547'],
#  }

#  rvm_gem {
#    'ruby-1.9.3-p547@puppet/nokogiri':
#      ensure  => '1.6.3.1',
#      require => Rvm_system_ruby['ruby-1.9.3-p547'],
#  }

#  rvm_gem {
#    'ruby-1.9.3-p547@puppet/aws-sdk':
#      ensure  => '1.52.0',
#      require => Rvm_system_ruby['ruby-1.9.3-p547'],
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
