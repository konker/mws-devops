
class server::gitolite {

    user { "git":
        ensure => present,
        home => "/home/git",
        shell => '/bin/bash',
        managehome => true,
    }

    package { "gitolite":
        ensure => present,
    }

    exec { "gl-setup":
        command => "/usr/bin/sudo -u git /usr/bin/env HOME=/home/git /usr/bin/gl-setup -q /var/keyshare/${::admin_user}_id_rsa.pub",
        creates => "/home/git/.gitolite",
        require => [ Package['gitolite'], Exec["${::admin_user}/publish-key"] ]
    }

    ssh_authorized_key { "git/$::admin_user@morningwoodsoftware.com":
        # /dev/null specified so that puppet runs before actual public key file is generated
        key => file("/home/$::admin_user/.ssh/id_rsa.pub", "/dev/null"),
        user => 'git',
        type => 'ssh-rsa',
        name => '',
        require => User[$::admin_user],
    }

    ssh_authorized_key { "git/konker@morningwoodsoftware.com":
        key => $::public_key,
        user => 'git',
        type => 'ssh-rsa',
        name => 'konker@morningwoodsoftware.com',
    }

    file { "git/WORKING":
        path => "/home/git/WORKING",
        ensure => directory,
        owner => 'git',
        group => 'git',
        require => User['git'],
    }

    #exec { "git/fetch-gitolite-admin":
        #command => "/usr/bin/sudo -u git /usr/bin/env HOME=/home/git /usr/bin/git clone git@localhost:gitolite-admin.git /home/git/WORKING/gitolite-admin",
        #creates => "/home/git/WORKING/gitolite-admin",
        #require => File["git/WORKING"],
    #}
}

