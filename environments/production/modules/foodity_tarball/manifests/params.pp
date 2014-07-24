class foodity_tarball::params {

  if $pkg_tgz =~ .*\.(gz|tgz)$ {
    $tar_options = "z"
  }
  $pkg_tgz =~ .*\.(bz|bz2) {
    $tar_options = "j"
  }
  else {
    fail("File $pkg_tgz extension is not known. Impossible to unzip")
  }

}
