define user::user ($user, $groups) {

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

    exec { "$user/ssh-keygen":
        command => "/usr/bin/sudo -u $user /usr/bin/env HOME=/home/$user /usr/bin/ssh-keygen -q -f /home/$user/.ssh/id_rsa -t rsa -N '' -C ${user}@morningwoodsoftware.com",
        creates => "/home/$user/.ssh/id_rsa.pub",
    }

    # ordering
    User[$user]
        -> File["$user/.ssh"] 
        -> Exec["$user/ssh-keygen"]
}

