class profiles::java {

  $webupd8src = '/etc/apt/sources.list.d/webupd8team.list'

  exec {'add-webupd8-repo':
        command => 'add-apt-repository -y ppa:webupd8team/java',
    path => '/usr/bin/',
  }->
  exec { 'apt-update':
    command => 'apt-get update',
    path => '/usr/bin/',
  }->
  exec { 'accept-java-license':
    command => '/bin/echo /usr/bin/debconf shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections;/bin/echo /usr/bin/debconf shared/accepted-oracle-license-v1-1 seen true | sudo /usr/bin/debconf-set-selections;',
  }->
  package { 'oracle-java7-installer':
    ensure => present,
  }->
  exec { 'update-java-alternatives':
          path    => '/usr/bin:/usr/sbin:/bin:/sbin',
          command => "update-alternatives --set java /usr/lib/jvm/java-7-oracle/jre/bin/java",
          unless  => "test /etc/alternatives/java -ef '/usr/lib/jvm/java-7-oracle/jre/bin/java'",
        }

}
