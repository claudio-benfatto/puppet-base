# == Class: tarball
#
# Full description of class tarball here.
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
#  class { tarball:
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
define foodity_tarball($pkg_tgz, $module_name, $install_dir) {

  if $pkg_tgz =~ /.*\.(gz|tgz)$/ {
    $tar_options = 'z'
  }
  elsif $pkg_tgz =~ /.*\.(bz2)$/ {
    $tar_options = 'j'
  }
  else {
    fail('File $pkg_tgz extension is not known. Impossible to unzip')
  }

  
  if ! defined(File[$install_dir]) {
    file { $install_dir:
      ensure => directory
    }
  }

    # download the tgz file
    file { $pkg_tgz:
        path    => "/tmp/${pkg_tgz}",
        source  => "puppet:///modules/${module_name}/${pkg_tgz}",
        notify  => Exec["untar ${pkg_tgz}"],
    }

    # untar the tarball at the desired location
    exec { "untar ${pkg_tgz}":
        environment => ["FILENAME=${pkg_tgz}"],
        command     => "rm -rf ${install_dir}/\${FILENAME%%.tar.*}; tar x${tar_options}vf /tmp/${pkg_tgz} -C ${install_dir}/; chown -R root:root ${install_dir}/\${FILENAME%%.tar.*}",
        refreshonly => true,
        path        => '/bin',
        require     => File["/tmp/${pkg_tgz}", $install_dir],
    }

}
