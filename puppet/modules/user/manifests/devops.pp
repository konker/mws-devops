define user::devops ($user) {

    notify { "setting up devops for $user": }

    # clone the devops repository from github
    exec { "$user/fetch-devops":
        command => "/usr/bin/sudo -u $user /usr/bin/git clone git@github.com:morningwoodsoftware/devops.git /home/$user/WORKING/devops",
        creates => "/home/$user/WORKING/devops",
        require => File["$user/WORKING"],
    }
}

