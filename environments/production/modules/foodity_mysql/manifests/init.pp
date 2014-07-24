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
class foodity_mysql {

  contain mysql::server

}

