$admin_user = 'sysadmin'
$workstation_user = 'konker'

$public_keys = [
    ['master',
     'AAAAB3NzaC1yc2EAAAABIwAAAQEAu73i+JZ/KhqdAVYCkzQEGAzh14jpGa3m3V8y/At07psIWq1bQpAnADQQkqJNsm5xgloDDlOQBeQAI4NnK1E7/aD3wkF0tDGA1S8myGhAHxGvogv5X5Ujq1wnUfF+048lioRZxcHkzULGBX5uF2PIRXX/v1My7uxzx8sgv+aQnjqv67qCAM92mNubA4U72Yzoy4ZsBsUflvTwZm2RlBlXrwdRBxQUtce/QPHJoBCvVVLElp6E0HtHuYMRVbFBAdH/D1rNvJcrM97w7WXih+Q4jOQed9jmR+VSM1arqTPtNh8J2lOWHwrriONeK823WUVHS4cNZJMhKnKYCAC8HegN2Q==',
    'konker@morningwoodsoftware.com']
]

$hostkeys = [
    ['github.com',
     'github.com,207.97.227.239',
     'AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ=='],
    ['localhost',
     'localhost,127.0.0.1',
     '/etc/ssh/ssh_host_rsa_key.pub']
]

$devops_ro_git_url = 'https://github.com/morningwoodsoftware/devops.git'
$devops_rw_git_url = 'git@github.com:morningwoodsoftware/devops.git'

Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

node "base" {
    include sudo::sudo
    include ssh::sshd
    include user::base
    include base::bin
}

node "sputnik", "mothership" inherits "base" {

    # set up ssh client
    include ssh::ssh

    # initialize the public key sharing directory
    include user::keyshare

    # set up system-wide development tools
    include development::tools

    # publish the 'master' public key
    user::publish_key { "${public_keys[0][0]}":
        user => $public_keys[0][0],
        key  => $public_keys[0][1],    
    }

    # create the admin user
    user::user { "$::admin_user": 
        user       => $::admin_user,
        groups     => ['sudo'],
    }

    # authorize the 'master' key for the admin user
    user::authorize_key { "$::admin_user":
        user                 => $::admin_user,
        key_label            => $::public_keys[0][0],
        authorize_public_key => $::public_keys[0][1],
        require              => User::User[$::admin_user],
    }

    # publish the admin user's public key
    user::publish_key { "$::admin_user":
        user    => $::admin_user,
        require => User::User[$::admin_user],
    }

    # set up a working environment from the admin user
    user::dotfiles { "${::admin_user}_dotfiles":
        user    => $::admin_user,
        require => User::User[$::admin_user],
    }

    # add host keys to global known_hosts
    ssh::sshkey { $::hostkeys[0][0]:
       name    => $::hostkeys[0][0],
       host    => $::hostkeys[0][1],
       key     => $::hostkeys[0][2],
       before  => User::User[$::admin_user],
       require => Class['Ssh::Sshd'],
    }

    ssh::sshkey { $::hostkeys[1][0]:
       name     => $::hostkeys[1][0],
       host     => $::hostkeys[1][1],
       key_file => $::hostkeys[1][2],
       before   => User::User[$::admin_user],
       require  => Class['Ssh::Sshd'],
    }

    # create a non-privileged workstation user
    user::user { "$::workstation_user": 
        user       => $::workstation_user,
        groups     => ['users'],
    }

     # authorize the 'master' key for the workstation user
    user::authorize_key { "$::workstation_user":
        user                 => $::workstation_user,
        key_label            => $::public_keys[0][0],
        authorize_public_key => $::public_keys[0][1],
        require              => User::User[$::workstation_user],
    }

    # publish the workstation user's public key
    user::publish_key { "$::workstation_user":
        user    => $::workstation_user,
        require => User::User[$::workstation_user],
    }

    # set up a working environment for the workstation user
    user::dotfiles { "${::workstation_user}_dotfiles":
        user    => $::workstation_user,
        require => User::User[$::workstation_user],
    }

    # set up gitolite git repository management server
    include server::gitolite::gitolite

    server::gitolite::conf { "gitolite-conf":
        user => $::admin_user,
    }

    # set up a devops working environment for the admin user
    user::devops { "${::admin_user}/devops":
        user    => $::admin_user,
        git_url => $::devops_rw_git_url,
    }
}
