class sudo::sudo {

    package { sudo: ensure => latest }

    # all members of admin group are sudoers
    # Note: don't also try to create user 'admin'
    group { "admin":
        ensure => present,
    }

    file { "/etc/sudoers":
        owner   => root,
        group   => root,
        mode    => 440,
        source  => "puppet:///modules/sudo/sudoers",
        require => Package["sudo"],
    }
}
