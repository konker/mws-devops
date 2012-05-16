define user::devops ($user) {

    # clone the devops repository from github
    exec { "$user/fetch-devops":
        command => "/usr/bin/sudo -u $user /usr/bin/env HOME=/home/$user /usr/bin/git clone git@localhost:devops.git /home/$user/WORKING/devops",
        creates => "/home/$user/WORKING/devops",
        require => [ File["$user/WORKING"], Exec['gl-setup'] ],
    }

    # Note: for this to be functional, syadmins public key will have to be authorized on github.com
    exec { "$user/add-devops-remote":
        command => "/usr/bin/sudo -u $user /usr/bin/env HOME=/home/$user /usr/bin/git remote add github git@github.com:morningwoodsoftware/devops.git",
        creates => "/home/$user/WORKING/devops",
        require => Exec["$user/fetch-devops"],
    }
}

