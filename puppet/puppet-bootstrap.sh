#!/bin/sh

# assumes that this is run with the correct permissions

# install the minimum needed for puppet to function
sudo apt-get -y install git
sudo apt-get -y install puppet

# fetch the manifests.
git clone https://github.com/morningwoodsoftware/devops ~/devops

# execute puppet on the manifest.
devops/puppet-exec.sh
