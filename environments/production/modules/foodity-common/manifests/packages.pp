class foodity-common::packages {

  
  create_resources('package', hiera_hash('software'))

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
