class ssh::knownhosts {

  $my_known_hosts = hiera_hash('node_known_hosts')

  create_resources(sshkey, $my_known_hosts)
}
