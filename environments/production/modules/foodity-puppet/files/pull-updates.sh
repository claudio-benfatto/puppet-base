#!/bin/sh
cd /etc/puppet
git checkout master && git clean -d -f && git checkout -- . && git pull && /usr/local/bin/papply
