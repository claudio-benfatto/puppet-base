# Class: foodity_php::packages
#
# This calss installs needed php packages for the foodity environment
#
# Parameters:
#
# Actions:
#   - Install php packages
#
# Requires:
#
# Sample Usage:
#
class foodity_php::packages {

  create_resources('Php::Module', hiera(php_modules))

}
