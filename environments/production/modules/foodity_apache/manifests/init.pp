# == Class: foodity_apache
#
# Full description of class foodity_apache here.
#
# === Parameters
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
#
# === Authors
#
#
# === Copyright
#
#
class foodity_apache( 
                     $apache_version = '2.4' ) {

  class {'::apache':
    mpm_module          => 'prefork',
    default_mods        => false,
    default_confd_files => false,
    apache_version      => $apache_version,   
  }

  $apache_modules = hiera('apache_modules')
  apache::mod { $apache_modules: }

  create_resources('file', hiera_hash('apache_folders'))
  create_resources('::apache::vhost', hiera_hash('apache_vhosts'))
}

