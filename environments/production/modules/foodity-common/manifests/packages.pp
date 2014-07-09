class foodity-common::packages {

  
  create_resources('package', hiera_hash('software'))

  package {'rubygems':
    ensure => present,
    before => ['Exec[deep_merge]', 'Exec[hiera-eyaml]', 'Exec[highline]'],
  }

  exec {'deep_merge':
    command => 'gem1.8 install deep_merge',
    path => '/usr/bin/',
    unless => 'test $(gem1.8 list --installed deep_merge == "true")',
  }

   exec {'hiera-eyaml':
    command => 'gem1.8 install hiera-eyaml',
    path => '/usr/bin',
    unless => 'test $(gem1.8 list --installed hiera-eyaml == "true")',
  }
 
  exec {'highline':
    command => 'gem1.8 install highline',
    path => '/usr/bin',
    unless => 'test $(gem1.8 list --installed highline == "true")',
  }

  package {'awscli':
    ensure   => present,
    provider => 'pip',
    require  => [File["${::root_home}/.aws"], Package['python-pip']],
  }

  package {'aws-sdk':
    ensure   => present,
    provider => 'gem',
    require  => [Package['build-essential'], Package['ruby1.9.1-dev']],
  }

  file {"${::root_home}/.aws":
    ensure  => directory,
    recurse => true,
    source  => "puppet:///modules/foodity-common/aws/config",
    owner   => 'root',
    group   => 'root',
    mode    => 0755,
  }

  file {"${::root_home}/dbimports":
    ensure => directory,
    owner   => 'root',
    group   => 'root',
    mode    => 0755,
  }

  exec {"ensure-correct-gem-version":
    command     => '/usr/sbin/update-alternatives --set gem /usr/bin/gem1.9.1',
    refreshonly => true,
    user        => 'root',
    subscribe   => Package['ruby1.9.1-dev'],
  }
}
