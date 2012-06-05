
class base::pre {
    # set up system-wide development tools
    class { "development::tools": }

    # publish the 'master' public key
    shared::publish_key { "${shared::consts::public_keys[0][0]}":
        label => $shared::consts::public_keys[0][0],
        key   => $shared::consts::public_keys[0][1],    
    }

    # publish the host keys
    shared::publish_key { $shared::consts::hostkeys[0][0]:
        label   => $shared::consts::hostkeys[0][0],
        key     => $shared::consts::hostkeys[0][2],
        keyfile => $shared::consts::hostkeys[0][3],
        require => Class[Ssh::Sshd],
    }

    shared::publish_key { $shared::consts::hostkeys[1][0]:
        label   => $shared::consts::hostkeys[1][0],
        key     => $shared::consts::hostkeys[1][2],
        keyfile => $shared::consts::hostkeys[1][3],
        require => Class[Ssh::Sshd],
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
    user::dotfiles { "${shared::consts::admin_user}_dotfiles":
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
    user::dotfiles { "${shared::consts::workstation_user}_dotfiles":
        user    => $shared::consts::workstation_user,
        require => User::User[$shared::consts::workstation_user],
    }

    # create the git user
    user::user { 'git':
        user   => 'git',
        groups => [],
    }

    # set up a working environment from the git user
    user::dotfiles { 'git_dotfiles':
        user    => 'git',
        require => User::User['git'],
    }
}
