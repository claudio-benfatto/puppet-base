# Class: foodity_puppet
#
# Configures the manifest and creates automation
# scripts
#
# Parameters:
#
# Actions:
#   - Configure puppet manifest
#
# Requires:
#
# Sample Usage:
#
class foodity_puppet {

  include ssh
  include foodity_common

  $ssh_git_remote = hiera('ssh_git_remote')
  create_resources('ssh::server::host_key', hiera(host_ssh_key))


  vcsrepo { '/etc/puppet':
    ensure  => 'present',
    provider => 'git',
    source   => 'git@git.foodity.com:claudio.benfatto/puppet-automation.git',
    revision => 'develop',
  }

  file { '/usr/local/bin/papply':
    source => 'puppet:///modules/foodity_puppet/papply.sh',
    mode   => '0755',
  }

#  file { '/usr/local/bin/pull-updates':
#    source => 'puppet:///modules/foodity_puppet/pull-updates.sh',
#    mode  => '0755',
#}

#  exec {'set-git-remote':
#    command => "git remote set-url origin ${ssh_git_remote}",
#    path    => '/usr/bin/:/bin/',
#    cwd     => '/etc/puppet',
#    unless  => "git remote show origin | grep ${ssh_git_remote} 2> /dev/null",
#    require => 'Package[git]',
#  }

  cron { 'run-puppet':
    ensure  => 'absent',
    user    => 'root',
    command => '/usr/local/bin/papply',
    minute  => '*/10',
    hour    => '*',
    require => ['Vcsrepo[/etc/puppet]', 'Sshkey[known_git.foodity.com_1]', 'Sshkey[known_git.foodity.com_2]'],
  }

}
