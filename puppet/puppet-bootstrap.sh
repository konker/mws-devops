#!/bin/sh

# assumes that this is run with the correct permissions

sudo apt-get update

# install the minimum needed for puppet to function
sudo apt-get -y install git
sudo apt-get -y install puppet

mkdir -f ~/WORKING

# fetch the manifests.
git clone https://github.com/morningwoodsoftware/devops ~/WORKING/devops

# execute puppet on the manifest.
echo "~/WORKING/devops/puppet/puppet-exec.sh"
