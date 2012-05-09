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

    ssh_authorized_key { "${user}@morningwoodsoftware.com":
        key => $authorize_public_key,
        user => $user,
        type => 'ssh-rsa',
    }

    exec { "$user/ssh-keygen":
        command => "/usr/bin/ssh-keygen -q -f /home/$user/.ssh/id_rsa -t rsa -N ''",
        creates => "/home/$user/.ssh/id_rsa",
    }

    # XXX: not for now.
    # admin user is member of sudo group -> no password needed
    # workstation user is not a sudoer
    ##exec { "$user/expire-password":
    ##    command => "/usr/bin/chage -d 0 $user",
    ##}

    # ordering
    User[$user]
        -> File["$user/.ssh"] 
        -> Ssh_authorized_key["${user}@morningwoodsoftware.com"] 
        -> Exec["$user/ssh-keygen"]
        #-> Exec["$user/expire-password"]
}

