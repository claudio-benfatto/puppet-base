# Class: site_web
#
# This module manages site_web
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class site_web($apacheversion = $site_web::params::apacheversion )
       inherits site_web::params {
}
