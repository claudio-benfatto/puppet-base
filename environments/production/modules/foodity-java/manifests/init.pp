class foodity-java {

  $webupd8src = '/etc/apt/sources.list.d/webupd8team.list'

  exec {'add-webupd8-repo':
        command => 'add-apt-repository -y ppa:webupd8team/java',
        path => '/bin/:/usr/bin/',
        unless => "update-alternatives --list java|grep java-7-oracle 2>/dev/null",
  }

  exec { 'add-webupd8-key':
    command => 'apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886',
    path => '/bin/:/usr/bin/',
    unless => "apt-key list | grep -c EEA14886 2>/dev/null",
    require => Exec['add-webupd8-repo'],
  }

  # update the apt keystore
  exec { 'apt-key-update':
    command => 'apt-key update',
    path => '/bin/:/usr/bin/',
    unless => "update-alternatives --list java|grep java-7-oracle 2>/dev/null",
    require => Exec['add-webupd8-key'],
  } 

  exec { 'apt-update':
    command => 'apt-get update',
    path => '/bin/:/usr/bin/',
    unless => "update-alternatives --list java|grep java-7-oracle 2>/dev/null",
    require => Exec['apt-key-update']
  }

  exec { 'accept-java-license':
    command => '/bin/echo /usr/bin/debconf shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections;/bin/echo /usr/bin/debconf shared/accepted-oracle-license-v1-1 seen true | sudo /usr/bin/debconf-set-selections;',
     unless => "update-alternatives --list java|grep java-7-oracle 2>/dev/null",
     path => '/bin/:/usr/bin/:',
     require => Exec['apt-update'],
  }

  package { 'oracle-java7-installer':
    ensure => present,
    require => Exec['accept-java-license'],
  }

  exec { 'update-java-alternatives':
          path    => '/usr/bin:/usr/sbin:/bin:/sbin',
          command => "update-alternatives --set java /usr/lib/jvm/java-7-oracle/jre/bin/java",
          unless  => "test /etc/alternatives/java -ef '/usr/lib/jvm/java-7-oracle/jre/bin/java'",
          require => Package['oracle-java7-installer'],
  }

}
