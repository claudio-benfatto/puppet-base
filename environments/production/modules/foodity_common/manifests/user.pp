# == Class: account
#
# Full description of class account here.
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
#  class { 'account':
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
define foodity_common::user (
                         $uid           = undef,
                         $gid           = undef,
                         $group         = undef,
                         $shell         = undef,
                         $home          = undef,
                         $ensure        = 'present',
                         $managehome    = true,
                         $manage_ssh    = true,
                         $comment       = 'puppet-managed user',
                         $groups        = undef,
                         $password      = undef,
                         $mode          = undef,
                         $ssh_auth_keys = undef,
                         $create_group  = true,
 ) {

  include sudo

  
  if $shell {
    $myshell = $shell
  } else {
    $myshell = '/bin/bash'
  }

  if $gid {
    $mygid = $gid
  } else {
    $mygid = $uid
  }

  if $groups {
    $mygroups = $groups
  } else {
    $mygroups = $name
  }

  if $group {
    $mygroup = $group
  } else {
    $mygroup = $name
  }

  if $password {
    $mypassword = $password
  } else {
    $mypassword = '!!'
  }

  if $home {
    $myhome = $home
  } else {
    $myhome = "/home/${name}"
  }

  if $mode {
    $mymode = $mode
  } else {
    $mymode = '0700'
  }


  user { $name:
    ensure     => $ensure,
    uid        => $uid,
    gid        => $mygid,
    shell      => $myshell,
    groups     => $mygroups,
    password   => $mypassword,
    managehome => $managehome,
    home       => $myhome,
    comment    => $comment,
  }


  if $create_group {
    group { $name:
      ensure    => $ensure,
      gid       => $mygid,
      name      => $mygroup,
    }
  }

  if $managehome == true {
    file { $myhome:
      owner    => $name,
      mode     => $mymode,
    }
  }

  $manage_ssh_type = type($manage_ssh)
  case $manage_ssh_type {
    'boolean': {
      $my_manage_ssh = $manage_ssh
    }
    'string': {
      $my_manage_ssh = str2bool($manage_ssh)
   }
   default: {
     fail("${name}::manage_ssh is type <${manage_ssh_type}> and must be boolean or string.")
   }
 }

  case $my_manage_ssh {
    true: {
      file { "${myhome}/.ssh":
        ensure      => directory,
        mode        => '0700',
        owner       => $name,
        group       => $name,
        require     => User[$name],
      }
   }
   false: { }
   default: {
     fail("${name}::manage_ssh is <${manage_ssh}> and must be true or false")
   }
  }



 if $ssh_auth_keys {
   
  $defaults = {
    'user'  => "${name}",
  }

  create_resources(ssh_authorized_key, $ssh_auth_keys, $defaults)

 }

}
