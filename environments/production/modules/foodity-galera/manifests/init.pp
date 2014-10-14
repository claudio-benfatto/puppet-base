# == Class: galera
#
# Full description of class galera here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'galera':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2014 Your name here, unless otherwise noted.
#
class foodity-galera {

class { 'galera':
#    galera_servers => [],
#    galera_master  => 'vagrant-ubuntu-trusty-64.foodity',

#    vendor_type => 'percona', # default is 'percona'

    # These options are only used for the firewall - 
    # to change the my.cnf settings, use the override options
    # described below

    local_ip => $::ipaddress_eth0, # This will be used to populate my.cnf values that control where wsrep binds, advertises, and listens
#    configure_repo => true, # Disable this if you are managing your own repos and mirrors
#    configure_firewall => false, # Disable this if you don't want firewall rules to be set
#    status_check => true,
#    validate_connection => true,
}

}
