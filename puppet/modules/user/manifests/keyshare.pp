class user::keyshare {
    file { "keyshare":
        path => "/var/keyshare",
        ensure => directory,
        owner => $::admin_user,
        group => $::admin_user,
        require => User[$::admin_user],
    }
}
