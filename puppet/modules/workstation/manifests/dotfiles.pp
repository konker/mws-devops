define dotfiles ($user) {
    file { 'WORKING':
        path => '/home/$user/WORKING',
        ensure => directory,
    }

    exec { 'fetch-dotfiles':
        command => 'git clone git://github.com/konker/dotfiles.git /home/$user/WORKING/dotfiles',
        require => File['WORKING'],
        before => [ Exec['vundle'], Exec['oh-my-zsh'] ],
    }

    exec { 'vundle':
        command => "git clone http://github.com/gmarik/vundle.git /home/$user/.vim/bundle/vundle",
        before => Exec['vundle-install'],
    }

    exec { 'vundle-install':
        command => "/usr/bin/vim +BundleInstall +qall",
    }

    exec { 'oh-my-zsh':
        command => "git clone git://github.com/robbyrussell/oh-my-zsh.git /home/$user/.oh-my-zsh",
    }

    file { "/home/$user/.zshrc":
       ensure => link,
       target => /home/$user/WORKING/dotfiles/.zshrc,
       require => Exec['fetch-dotfiles'],
    }

    file { "/home/$user/.vimrc":
       ensure => link,
       target => /home/$user/WORKING/dotfiles/.vimrc,
       require => Exec['fetch-dotfiles'],
    }

    file { "/home/$user/.screenrc":
       ensure => link,
       target => /home/$user/WORKING/dotfiles/.screenrc,
       require => Exec['fetch-dotfiles'],
    }
}
