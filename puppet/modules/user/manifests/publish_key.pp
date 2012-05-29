define user::publish_key ($user, $key='') {

    if $key == '' {
        file { "$user/publish_key":
            path    => "/var/keyshare/${user}_id_rsa.pub",
            ensure  => file,
            content => generate('/usr/bin/find', "/home/$user/.ssh", '-name', 'id_rsa.pub', '-exec', '/usr/bin/cut', '-c', '9-', '{}', '\\;'),
            #content => generate('/usr/bin/cut', '-c', '9-', "/home/$user/.ssh/id_rsa.pub"),
            #content => file("/home/$user/.ssh/id_rsa.pub", '/dev/null'),
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
