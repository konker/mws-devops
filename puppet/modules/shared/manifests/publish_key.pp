
define shared::publish_key ($label, $user='', $key='', $keyfile='') {

    if $keyfile == '' {
        if $key == '' {
            if $user == '' {
                notify { "publish key failed for ${label}: no user, key or keyfile given": }
            }
            else {
                file { "$label/publish_key_bare":
                    path    => "${shared::keyshare::keyshare_path}/${label}_id_rsa.pub.bare",
                    ensure  => file,
                    content => generate('/usr/bin/cut', '-d', ' ', '-f2', "/home/$user/.ssh/id_rsa.pub"),
                    owner   => $shared::consts::admin_user,
                    group   => $shared::consts::admin_user,
                    mode    => 644,
                    require => File['keyshare'],
                }
                file { "$label/publish_key":
                    path    => "${shared::keyshare::keyshare_path}/${label}_id_rsa.pub",
                    ensure  => file,
                    content => file("/home/$user/.ssh/id_rsa.pub"),
                    owner   => $shared::consts::admin_user,
                    group   => $shared::consts::admin_user,
                    mode    => 644,
                    require => File['keyshare'],
                }
            }
        }
        else {
            file { "$label/publish_key_bare":
                path    => "${shared::keyshare::keyshare_path}/${label}_id_rsa.pub.bare",
                ensure  => file,
                content => $key,
                owner   => $shared::consts::admin_user,
                group   => $shared::consts::admin_user,
                mode    => 644,
                require => File['keyshare'],
            }
            file { "$label/publish_key":
                path    => "${shared::keyshare::keyshare_path}/${label}_id_rsa.pub",
                ensure  => file,
                content => "ssh-rsa $key $label",
                owner   => $shared::consts::admin_user,
                group   => $shared::consts::admin_user,
                mode    => 644,
                require => File['keyshare'],
            }
        }
    }
    else {
        file { "$label/publish_key_bare":
            path    => "${shared::keyshare::keyshare_path}/${label}_id_rsa.pub.bare",
            ensure  => file,
            content => generate('/usr/bin/cut', '-d', ' ', '-f2', $keyfile),
            owner   => $shared::consts::admin_user,
            group   => $shared::consts::admin_user,
            mode    => 644,
            require => File['keyshare'],
        }
        file { "$label/publish_key":
            path    => "${shared::keyshare::keyshare_path}/${label}_id_rsa.pub",
            ensure  => file,
            content => file($keyfile),
            owner   => $shared::consts::admin_user,
            group   => $shared::consts::admin_user,
            mode    => 644,
            require => File['keyshare'],
        }
    }
}
