
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

node "base" {
    include sudo::sudo
    include ssh::sshd
    include user::base
    include base::bin
}

node "sputnik", "mothership" inherits "base" {

    include shared::consts

    # initialize the public key sharing directory
    include shared::keyshare

    # set up ssh client
    include ssh::ssh

    # set up system-wide development tools
    include development::tools

    # publish the 'master' public key
    shared::publish_key { "${shared::consts::public_keys[0][0]}":
        label => $shared::consts::public_keys[0][0],
        key   => $shared::consts::public_keys[0][1],    
    }

    # create the admin user
    user::user { "$shared::consts::admin_user": 
        user       => $shared::consts::admin_user,
        groups     => ['sudo'],
    }

    # authorize the 'master' key for the admin user
    user::authorize_key { "$shared::consts::admin_user":
        user                 => $shared::consts::admin_user,
        key_label            => $shared::consts::public_keys[0][0],
        authorize_public_key => $shared::consts::public_keys[0][1],
        require              => User::User[$shared::consts::admin_user],
    }

    # set up a working environment for the admin user
    user::dotfiles { "${::admin_user}_dotfiles":
        user    => $shared::consts::admin_user,
        require => User::User[$shared::consts::admin_user],
    }

    # create a non-privileged workstation user
    user::user { "$shared::consts::workstation_user": 
        user       => $shared::consts::workstation_user,
        groups     => ['users'],
    }

    # authorize the 'master' key for the workstation user
    user::authorize_key { "$shared::consts::workstation_user":
        user                 => $shared::consts::workstation_user,
        key_label            => $shared::consts::public_keys[0][0],
        authorize_public_key => $shared::consts::public_keys[0][1],
        require              => User::User[$shared::consts::workstation_user],
    }

    # set up a working environment for the workstation user
    user::dotfiles { "${::workstation_user}_dotfiles":
        user    => $shared::consts::workstation_user,
        require => User::User[$shared::consts::workstation_user],
    }

    # create the git user
    user::user { "git":
        user   => 'git',
        groups => [],
    }

    # set up a working environment from the git user
    user::dotfiles { 'git_dotfiles':
        user    => 'git',
        require => User::User['git'],
    }
}
