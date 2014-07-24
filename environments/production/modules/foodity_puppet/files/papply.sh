#!/bin/sh
sudo puppet apply /etc/puppet/environments/production/manifests/site.pp --modulepath=/etc/puppet/environments/production/modules/ $*
