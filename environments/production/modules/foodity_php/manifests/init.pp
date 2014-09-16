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
    include foodity_mysql
  }
  
  if $with_apache {
    include foodity_apache
  }

  contain foodity_php::packages

}
