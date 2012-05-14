define user::user ($user, $groups, $authorize_public_key) {

    user { "$user":
        ensure => present,
        groups => $groups,
        home => "/home/$user",
        shell => '/bin/zsh',
        managehome => true,
    }

    file { "$user/.ssh":
        path => "/home/$user/.ssh",
        ensure => directory,
        owner => $user,
        group => $user,
        mode => 600,
    }

    ssh_authorized_key { "${user}/master@morningwoodsoftware.com":
        key => $authorize_public_key,
        user => $user,
        type => 'ssh-rsa',
    }

    exec { "$user/ssh-keygen":
        command => "/usr/bin/sudo -u $user /usr/bin/env HOME=/home/$user /usr/bin/ssh-keygen -q -f /home/$user/.ssh/id_rsa -t rsa -N '' -C ${user}@morningwoodsoftware.com",
        creates => "/home/$user/.ssh/id_rsa.pub",
    }

    exec { "$user/publish-key":
        command => "/bin/cp /home/$user/.ssh/id_rsa.pub /var/keyshare/${user}_id_rsa.pub",
        creates => "/var/keyshare/${user}_id_rsa.pub",
        require => File['keyshare'],
    }

    # ordering
    User[$user]
        -> File["$user/.ssh"] 
        -> Ssh_authorized_key["${user}/master@morningwoodsoftware.com"] 
        -> Exec["$user/ssh-keygen"]
        -> Exec["$user/publish-key"]
}

