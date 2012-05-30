
class server::gitolite::gitolite {

    include shared::consts
    include shared::keyshare

    package { "gitolite":
        ensure => present,
    }

    exec { "gl-setup":
        command => "exec-as git gl-setup -q ${shared::keyshare::keyshare_path}/${shared::consts::admin_user}_id_rsa.pub",
        creates => "/home/git/.gitolite",
        require => [ Package['gitolite'], Shared::Publish_key["${shared::consts::admin_user}"] ]
    }

    # NOTE: do not try to authorize keys from gitolite using ssh_authorized_key
    
    # mirror the devops repo under gitolite
    exec { "mirror-devops":
        command => "exec-as git git clone --mirror $shared::consts::devops_ro_git_url /home/git/repositories/devops.git",
        creates => "/home/git/repositories/devops.git",
        require => Exec['gl-setup'],
    }
    
    # set the origin remote url to rw version
    exec { "rw-origin-devops":
        command => "exec-as git git remote set-url origin $shared::consts::devops_rw_git_url",
        require => Exec['mirror-devops'],
    }

    # create git post-update hook for the devops repo under gitolte
    file { "devops-post-update":
        path    => '/home/git/repositories/devops.git/hooks/post-update',
        ensure  => file,
        source  => 'puppet:///modules/server/devops/post-update',
        owner   => 'git',
        group   => 'git',
        mode    => 755,
        require => Exec['mirror-devops'],
    }

    # clone the gitolite-admin repo for admin_user
    exec { "$shared::consts::admin_user/fetch-gitolite-admin":
        command => "exec-as $shared::consts::admin_user git clone git@localhost:gitolite-admin.git /home/$shared::consts::admin_user/WORKING/gitolite-admin",
        creates => "/home/$shared::consts::admin_user/WORKING/gitolite-admin",
        require => File["$shared::consts::admin_user/WORKING"],
    }
}

