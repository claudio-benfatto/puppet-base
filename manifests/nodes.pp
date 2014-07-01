node 'puppet-agent' {
	include apache2
}

node 'puppet' {
    include test_class
}
