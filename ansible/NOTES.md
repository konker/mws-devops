Devops notes
==============================================================================

## Pre phase
- yum/apt update
- install python
- install python-apt

## Boot phase
- create admin user
- add admin user to sudoers
- disable root

## Main phase
- zsh
- install tmux
- install git
- create git user
    - install gitolite
- install gpg
- create konker user
    - dotfiles/etc
- install nginx
- install web sites
    - as git repos auto pulled -> www
    - middleman?
    - have web sites running on s3/cloudfront?
    - install ssh cert
- install backup process
    - rsync -> archive -> encrypt -> s3
        - ?
        - or use tarsnap?

## Extra phase
- install irssi
- install bitlbee
- install bitlebee-otr

