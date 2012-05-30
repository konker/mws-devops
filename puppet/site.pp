
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

node "sputnik", "mothership" {

    class { "base": }
    class { "base::pre": }

    include shared::consts
    include shared::keyshare

    # publish the admin user's public key
    shared::publish_key { "$shared::consts::admin_user":
        label   => $shared::consts::admin_user,
        user    => $shared::consts::admin_user,
        require => User::User[$shared::consts::admin_user],
    }

    # publish the workstation user's public key
    shared::publish_key { "$shared::consts::workstation_user":
        label   => $shared::consts::workstation_user,
        user    => $shared::consts::workstation_user,
        require => User::User[$shared::consts::workstation_user],
    }

    # publish the git user's public key
    shared::publish_key { 'git':
        label   => 'git',
        user    => 'git',
        require => User::User['git'],
    }

    # add host keys to global known_hosts
    sshkey { $shared::consts::hostkeys[0][1]:
        type => 'ssh-rsa',
        key => file("${shared::keyshare::keyshare_path}/${shared::consts::hostkeys[0][0]}_id_rsa.pub.bare", '/dev/null'),
        ensure => present,
        require => [ Package["openssh-client"], Shared::Publish_key[$shared::consts::hostkeys[0][0]] ],
    }

    sshkey { $shared::consts::hostkeys[1][1]:
        type => 'ssh-rsa',
        key => file("${shared::keyshare::keyshare_path}/${shared::consts::hostkeys[1][0]}_id_rsa.pub.bare", '/dev/null'),
        ensure => present,
        require => [ Package["openssh-client"], Shared::Publish_key[$shared::consts::hostkeys[1][0]] ],
    }

    # set up a devops working environment for the admin user
    user::devops { "${::admin_user}/devops":
        user    => $shared::consts::admin_user,
        git_url => $shared::consts::devops_rw_git_url,
    }

    # set up gitolite git repository management server
    include server::gitolite::gitolite

    server::gitolite::conf { 'gitolite-conf':
        user => $shared::consts::admin_user,
    }
}
