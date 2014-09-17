# Class: foodity_php
#
# This class configure php for a foodity environment
#
# Parameters:
#
# Actions:
#   - Configure php
#
# Requires:
#
# Sample Usage:
#
class foodity_php ( $with_mysql  = false,
                    $with_apache = false ) {

  if $with_mysql {
    class { 'foodity_mysql':  
             with_mysql_client => true,
    }
  }
  
  if $with_apache {
    include foodity_apache
  }

  contain foodity_php::packages

}
