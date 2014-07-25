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
class foodity_php {

  include foodity_mysql
  include foodity_apache

  contain foodity_php::packages

}
