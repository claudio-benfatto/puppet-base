class foodity-common::packages {

  
  create_resources('package', hiera_hash('software'))

  package {'rubygems':
    ensure => present,
    before => ['Exec[deep_merge]', 'Exec[hiera-eyaml]', 'Exec[highline]'],
  }

  exec {'deep_merge':
    command => 'gem1.8 install deep_merge',
    path => '/usr/bin/:/bin/',
    unless => 'gem1.8 list | grep -c deep_merge',
  }

   exec {'hiera-eyaml':
    command => 'gem1.8 install hiera-eyaml',
    path => '/usr/bin:/bin/',
    unless => 'gem1.8 list | grep -c hiera-eyaml',
  }
 
  exec {'highline':
    command => 'gem1.8 install highline',
    path => '/usr/bin:/bin/',
    unless => 'gem1.8 list | grep -c highline',
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
