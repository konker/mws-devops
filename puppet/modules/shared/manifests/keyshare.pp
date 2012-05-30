
$keyshare_path = "/var/keyshare"

class shared::keyshare {

    include shared::consts

    file { "keyshare":
        path => $keyshare_path,
        ensure => directory,
        owner => $shared::consts::admin_user,
        group => $shared::consts::admin_user,
        require => User[$::admin_user],
    }
}
