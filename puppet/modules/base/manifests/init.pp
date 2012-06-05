
class base {
    include shared::consts
    include shared::keyshare

    class { "sudo::sudo": }
    class { "ssh::sshd": }
    class { "user::base": }
    class { "base::bin": }
    class { "ssh::ssh": }
}
