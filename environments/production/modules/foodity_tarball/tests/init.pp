# The baseline for module testing used by Puppet Labs is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation
# errors and view a log of events) or by fully applying the test in a virtual
# environment (to compare the resulting system state to the desired state).
#
# Learn more about module testing here:
# http://docs.puppetlabs.com/guides/tests_smoke.html
#


foodity_tarball { 'test.gz':
  pkg_tgz     => 'test.tar.gz',
  module_name => 'foodity_tarball',
  install_dir => '/tmp',
}

foodity_tarball { 'test.bz2':
  pkg_tgz     => 'test.tar.bz2',
  module_name => 'foodity_tarball',
  install_dir => '/tmp',
}

foodity_tarball { 'test.zip':
  pkg_tgz     => 'test.tar.zip',
  module_name => 'foodity_tarball',
  install_dir => '/tmp',
}

