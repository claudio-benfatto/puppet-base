# Class: foodity_phantomjs
#
# This class installs phantomjs library
#
# Parameters:
#
# Actions:
#   - Install phantomjs
#
# Requires:
#
# Sample Usage:
#
class foodity_phantomjs {

  foodity_tarball { 'phantomjs-1.6.1':
    module_name => 'foodity_phantomjs',
    install_dir => '/usr/local',
    pkg_tgz     => 'phantomjs-1.6.1-linux-x86_64-dynamic.tar.bz2',
    before      => File['/usr/local/bin/phantomjs'],
  }

  file { '/usr/local/bin/phantomjs':
    ensure => 'link',
    target => '/usr/local/phantomjs-1.6.1-linux-x86_64-dynamic/bin/phantomjs',
  }

}
