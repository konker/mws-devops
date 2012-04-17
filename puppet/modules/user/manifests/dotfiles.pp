define user::dotfiles ($user) {

    notify { "setting up workstation for $user": }
    file { "$user/WORKING":
        path => "/home/$user/WORKING",
        ensure => directory,
        owner => $user,
        group => $user,
        require => User[$user],
        before => Exec["$user/fetch-dotfiles"],
    }

    # clone the dotfiles repository from github
    exec { "$user/fetch-dotfiles":
        command => "/usr/bin/sudo -u $user /usr/bin/git clone git://github.com/konker/dotfiles.git /home/$user/WORKING/dotfiles",
        creates => "/home/$user/WORKING/dotfiles",
        require => File["$user/WORKING"],
        before => [ Exec["$user/vundle"], Exec["$user/oh-my-zsh"] ],
    }

    exec { "$user/vundle":
        command => "/usr/bin/sudo -u $user /usr/bin/git clone http://github.com/gmarik/vundle.git /home/$user/.vim/bundle/vundle",
        creates => "/home/$user/.vim/bundle/vundle",
        require => Exec["$user/fetch-dotfiles"],
    }

    # run VundleInstall without actually starting vim
    exec { "$user/vundle-install":
        command => "/usr/bin/sudo -u $user /usr/bin/vim +BundleInstall +qall",
        require => Exec["$user/vundle"],
    }

    exec { "$user/oh-my-zsh":
        command => "/usr/bin/sudo -u $user /usr/bin/git clone git://github.com/robbyrussell/oh-my-zsh.git /home/$user/.oh-my-zsh",
        creates => "/home/$user/.oh-my-zsh",
        require => Exec["$user/fetch-dotfiles"],
    }

    # link dotfiles to the ones in the git repository
    file { "/home/$user/.zshrc":
        ensure => link,
        target => "/home/$user/WORKING/dotfiles/.zshrc",
        owner => $user,
        group => $user,
        require => Exec["$user/fetch-dotfiles"],
    }

    file { "/home/$user/.vimrc":
        ensure => link,
        target => "/home/$user/WORKING/dotfiles/.vimrc",
        owner => $user,
        group => $user,
        require => Exec["$user/fetch-dotfiles"],
    }

    file { "/home/$user/.screenrc":
        ensure => link,
        target => "/home/$user/WORKING/dotfiles/.screenrc",
        owner => $user,
        group => $user,
        require => Exec["$user/fetch-dotfiles"],
    }

    file { "/home/$user/.tmux.conf":
        ensure => link,
        target => "/home/$user/WORKING/dotfiles/.tmux.conf",
        owner => $user,
        group => $user,
        require => Exec["$user/fetch-dotfiles"],
    }
}

