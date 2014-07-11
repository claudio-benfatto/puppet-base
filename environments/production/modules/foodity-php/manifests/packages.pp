class foodity-php::packages {

  create_resources('package', hiera(php_software))

}
