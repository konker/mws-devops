#!/bin/sh

#cd ~/devops
#git pull origin master

# execute puppet on the manifest.
sudo puppet apply site.pp --modulepath modules
