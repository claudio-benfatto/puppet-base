# Class: foodity_mysql
#
# This class configure mysql for a foodity environment
#
# Parameters:
#
# Actions:
#   - Configure mysql
#
# Requires:
#
# Sample Usage:
#
class foodity_mysql ( $with_mysql_client = true) {

  include mysql::server

  if $with_mysql_client {
    include mysql::client
  }

}

