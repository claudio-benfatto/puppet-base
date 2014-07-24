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

  $ssh_git_remote = hiera('ssh_git_remote')
  create_resources('ssh::server::host_key', hiera(host_ssh_keys))


  file { '/usr/local/bin/papply':
    source => 'puppet:///modules/foodity_puppet/papply.sh',
    mode   => '0755',
  }

  file { '/usr/local/bin/pull-updates':
    source => 'puppet:///modules/foodity_puppet/pull-updates.sh',
    mode   => '0755',
}

  exec {'set-git-remote':
    command => "git remote set-url origin ${ssh_git_remote}",
    path    => '/usr/bin/:/bin/',
    cwd     => '/etc/puppet',
    unless  => "git remote show origin | grep ${ssh_git_remote} 2> /dev/null",
    require => 'Package[git]',
  }

  cron { 'run-puppet':
    ensure  => 'absent',
    user    => 'root',
    command => '/usr/local/bin/pull-updates',
    minute  => '*/10',
    hour    => '*',
    require => ['Exec[set-git-remote]', 'File[/root/.ssh/id_rsa]', 'Exec[add_known_hosts]' ]
  }

}
