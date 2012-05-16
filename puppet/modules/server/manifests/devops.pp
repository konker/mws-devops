class server::devops {

    file { "devops-hooks-dir":
        path    => '/home/git/.gitolite/hooks/devops',
        ensure  => directory,
        owner   => 'git',
        group   => 'git',
        require => User['git'],
    }

    # create git post-update hook for the devops repo under gitolte
    file { "devops-post-update":
        path    => '/home/git/.gitolite/hooks/devops/post-update',
        ensure  => file,
        source  => 'puppet:///modules/server/devops/post-update',
        owner   => 'git',
        group   => 'git',
        mode    => 755,
        require => File['devops-hooks-dir'],
    }
}
