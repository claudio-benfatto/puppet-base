#!/bin/sh
cd /etc/puppet
git checkout master && git pull && /usr/local/bin/papply
