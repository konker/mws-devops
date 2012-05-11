define user::devops ($user) {

    notify { "setting up devops for $user": }

    # clone the devops repository from github
    exec { "$user/fetch-devops":
        command => "/usr/bin/sudo -u $user /usr/bin/env HOME=/home/$user /usr/bin/git clone https://konker@github.com/morningwoodsoftware/devops.git /home/$user/WORKING/devops",
        creates => "/home/$user/WORKING/devops",
        require => File["$user/WORKING"],
    }

    # Note: for this to be functional, syadmins public key will have to be authorized on github.com
    exec { "$user/add-devops-remote":
        command => "/usr/bin/sudo -u $user /usr/bin/env HOME=/home/$user /usr/bin/git remote set-url origin git@github.com:morningwoodsoftware/devops.git",
        creates => "/home/$user/WORKING/devops",
        require => Exec["$user/fetch-devops"],
    }
}

