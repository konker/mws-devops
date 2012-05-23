
class server::gitolite::gitolite {

    user::user { "git":
        user   => 'git',
        groups => [],
    }
    #user { "git":
    #    ensure => present,
    #    home => "/home/git",
    #    shell => '/bin/bash',
    #    managehome => true,
    #}

    package { "gitolite":
        ensure => present,
    }

    exec { "gl-setup":
        command => "exec-as git gl-setup -q /var/keyshare/${::admin_user}_id_rsa.pub",
        creates => "/home/git/.gitolite",
        require => [ Package['gitolite'], User::Publish_key["${::admin_user}"] ]
    }

    # NOTE: do not try to authorize keys from gitolite using ssh_authorized_key
    
    # mirror the devops repo under gitolite
    exec { "mirror-devops":
        command => "exec-as git git clone --mirror $::devops_ro_git_url /home/git/repositories/devops.git",
        creates => "/home/git/repositories/devops.git",
        require => Exec['gl-setup'],
    }

    # create git post-update hook for the devops repo under gitolte
    #file { "devops-post-update":
    #    path    => '/home/git/repositories/devops.git/hooks/post-update.secondary',
    #    ensure  => file,
    #    source  => 'puppet:///modules/server/devops/post-update',
    #    owner   => 'git',
    #    group   => 'git',
    #    mode    => 755,
    #    require => Exec['mirror-devops'],
    #}

    # clone the gitolite-admin repo for admin_user
    exec { "$::admin_user/fetch-gitolite-admin":
        command => "exec-as $::admin_user git clone git@localhost:gitolite-admin.git /home/$::admin_user/WORKING/gitolite-admin",
        creates => "/home/$::admin_user/WORKING/gitolite-admin",
        require => File["$::admin_user/WORKING"],
    }
}

