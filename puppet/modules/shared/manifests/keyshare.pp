

class shared::keyshare {

    include shared::consts

    $keyshare_path = '/var/keyshare'

    file { "keyshare":
        path    => $keyshare_path,
        ensure  => directory,
        owner   => $shared::consts::admin_user,
        group   => $shared::consts::admin_user,
        mode    => 700,
        require => User[$shared::consts::admin_user],
    }
}
