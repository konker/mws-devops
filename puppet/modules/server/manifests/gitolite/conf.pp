
define server::gitolite::conf ($user) {
    
    $work_tree = "/home/$user/WORKING/gitolite-admin"
    $git_dir = "/home/$user/WORKING/gitolite-admin/.git"

    file { "${user}/gitolite-conf":
        path    => "/home/$user/WORKING/gitolite-admin/conf/gitolite.conf",
        source  => "puppet:///modules/server/gitolite/gitolite.conf",
        require => [ Class['Server::Gitolite::Gitolite'] ],
    }

    exec { "${user}/add-gitolite-conf":
        command => "exec-as $user git --work-tree=$work_tree --git-dir=$git_dir add $work_tree",
        require => File["${user}/gitolite-conf"],
    }

    exec { "${user}/commit-gitolite-conf":
        #command => "exec-as $user git --work-tree=$work_tree --git-dir=$git_dir diff-files --quiet || exec-as $user git --work-tree=$work_tree --git-dir=$git_dir commit -am 'Puppet auto-commit Exec[${user}/Commit-gitolite-conf]'",
        command => "exec-as $user git --work-tree=$work_tree --git-dir=$git_dir commit -q -a -m 'Puppet auto-commit Exec[${user}/Commit-gitolite-conf]' || true",
        require => Exec["${user}/add-gitolite-conf"],
    }

    exec { "${user}/push-gitolite-conf":
        command => "exec-as $user git --work-tree=$work_tree --git-dir=$git_dir push origin master",
        require   => Exec["${user}/commit-gitolite-conf"],
    }
}
