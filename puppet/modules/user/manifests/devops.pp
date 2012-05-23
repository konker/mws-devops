define user::devops ($user, $git_url) {
    
    $work_tree = "/home/$user/WORKING/devops"
    $git_dir = "/home/$user/WORKING/devops/.git"

    # clone the devops repository from github
    exec { "$user/fetch-devops":
        command => "exec-as $user git clone git@localhost:devops.git $work_tree",
        creates => $work_tree,
        require => [ File["$user/WORKING"], Exec["$user/push-gitolite-conf"] ],
    }

    # Note: for this to be functional, syadmins public key will have to be authorized on github.com
    exec { "$user/add-devops-remote":
        command => "exec-as $user git --work-tree=$work_tree --git-dir=$git_dir remote add github $git_url || true",
        require => Exec["$user/fetch-devops"],
    }
}

