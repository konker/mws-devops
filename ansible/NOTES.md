Devops notes
==============================================================================
- open, P postpome, N don't do, X done

## Pre phase (non-ansible)
- yum/apt update
- install python
- install python-apt

## Boot phase
x zsh
x create admin user
x add admin user to sudoers
x disable root

## Main phase
x install git
x install ntp
x install tmux
- install gpg
- create git user
    - install gitolite
x create konker user
    - dotfiles/etc
x create application user
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
P install irssi
P install bitlbee
P install bitlebee-otr

