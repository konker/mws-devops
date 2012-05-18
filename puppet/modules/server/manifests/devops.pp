class server::devops {

    #file { "devops-hooks-dir":
    #    path    => '/home/git/.gitolite/hooks/common',
    #    ensure  => directory,
    #    owner   => 'git',
    #    group   => 'git',
    #    require => [ User['git'], Exec['gl-setup'] ],
    #}

    # create git post-update hook for the devops repo under gitolte
    #file { "devops-post-update":
    #    path    => '/home/git/repositories/devops.git/hooks/post-update',
    #    ensure  => file,
    #    source  => 'puppet:///modules/server/common/post-update',
    #    owner   => 'git',
    #    group   => 'git',
    #    mode    => 755,
    #    require => File['devops-hooks-dir'],
    #}
}
