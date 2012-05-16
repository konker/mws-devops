define user::publish_key ($user, $key='') {

    if $key == '' {
        exec { "$user/publish_key":
            command => "/bin/cp /home/$user/.ssh/id_rsa.pub /var/keyshare/${user}_id_rsa.pub",
            creates => "/var/keyshare/${user}_id_rsa.pub",
            require => File['keyshare'],
        }
    }
    else {
        file { "$user/publish_key":
            path => "/var/keyshare/${user}_id_rsa.pub",
            content => $key,
            require => File['keyshare'],
        }
    }
}
