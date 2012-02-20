#!/bin/sh

cd ~/devops
git pull origin master

# execute puppet on the manifest.
sudo puppet apply puppet/init.pp --modulepath ~/devops/puppet/modules
