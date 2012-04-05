define user::user ($user, $groups, $public_key) {
    package { "zsh":
        ensure => present,
    }

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
        key => $public_key,
        user => $user,
        type => 'ssh-rsa',
    }

    exec { "$user/ssh-keygen":
        command => "/usr/bin/ssh-keygen -q -f /home/$user/.ssh/id_rsa -t rsa -N ''",
        creates => "/home/$user/.ssh/id_rsa",
    }

    exec { "$user/expire-password":
        command => "sudo chage -d 0 $user",
    }

    # ordering
    User[$user]
        -> File["$user/.ssh"] 
        -> Ssh_authorized_key["${user}@morningwoodsoftware.com"] 
        -> Exec["$user/ssh-keygen"]
        -> Exec["$user/expire-password"]
}

