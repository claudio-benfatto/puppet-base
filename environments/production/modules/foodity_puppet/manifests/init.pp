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

  if $::manifest_revision {
    $git_manifest_revision = $::manifest_revision
  }
  else
    { fail("Unable to find manifest_revion variable among puppet facts. Aborting") }


  vcsrepo { '/etc/puppet':
    ensure   => 'present',
    provider => 'git',
    source   => 'git@git.foodity.com:claudio.benfatto/puppet-automation.git',
    revision => $git_manifest_revision,
    require  => 'File[/root/.ssh/id_rsa]',
  }

  file { '/usr/local/bin/papply':
    source => 'puppet:///modules/foodity_puppet/papply.sh',
    mode   => '0755',
  }

  cron { 'run-puppet':
    ensure  => 'absent',
    user    => 'root',
    command => '/usr/local/bin/papply',
    minute  => '*/10',
    hour    => '*',
    require => ['Vcsrepo[/etc/puppet]', 'Sshkey[known_git.foodity.com_1]', 'Sshkey[known_git.foodity.com_2]'],
  }

}
