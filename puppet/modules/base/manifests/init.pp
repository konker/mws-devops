
class base {
    include sudo::sudo
    include ssh::sshd
    include user::base
    include base::bin

    include shared::consts

    # initialize the public key sharing directory
    include shared::keyshare

    # set up ssh client
    include ssh::ssh
}
