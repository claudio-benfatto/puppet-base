package {
	'apache2':
		ensure => installed
}

service {
	'apache2':
		ensure => true,
		enable => true,
		require => Package['apache2']
}



 file {'/tmp/test1':
      ensure  => file,
      content => "Hi.\n",
    }

file {'/tmp/test2':
      ensure => directory,
      mode   => 0644,
    }

    file {'/tmp/test3':
      ensure => link,
      target => '/tmp/test1',
    }


class test_class {
   file { "/tmp/claudio":
      ensure => present,
      mode   => 644,
      owner  => root,
      group  => root
    }
}
