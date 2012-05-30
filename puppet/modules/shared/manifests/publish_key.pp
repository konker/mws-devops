
define shared::publish_key ($label, $user='', $key='', $keyfile='') {

    if $keyfile == '' {
        if $key == '' {
            if $user == '' {
                notify { "publish key failed for ${label}: no user, key or keyfile given": }
            }
            else {
                file { "$label/publish_key":
                    path    => "${shared::keyshare::keyshare_path}/${label}_id_rsa.pub",
                    ensure  => file,
                    content => generate('/usr/bin/cut', '-c', '9-', "/home/$user/.ssh/id_rsa.pub"),
                    owner   => $shared::consts::admin_user,
                    group   => $shared::consts::admin_user,
                    mode    => 644,
                    require => File['keyshare'],
                }
            }
        }
        else {
            file { "$label/publish_key":
                path    => "${shared::keyshare::keyshare_path}/${label}_id_rsa.pub",
                ensure  => file,
                content => $key,
                owner   => $shared::consts::admin_user,
                group   => $shared::consts::admin_user,
                mode    => 644,
                require => File['keyshare'],
            }
        }
    }
    else {
        file { "$label/publish_key":
            path    => "${shared::keyshare::keyshare_path}/${label}_id_rsa.pub",
            ensure  => file,
            content => generate('/usr/bin/cut', '-c', '9-', $keyfile),
            owner   => $shared::consts::admin_user,
            group   => $shared::consts::admin_user,
            mode    => 644,
            require => File['keyshare'],
        }
    }
}
