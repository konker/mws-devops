#!/bin/sh

cd ~/WORKING/devops
git pull origin master

# execute puppet on the manifest.
sudo puppet apply puppet/pre_site.pp --modulepath puppet/modules \
 && sudo puppet apply puppet/site.pp --modulepath puppet/modules

