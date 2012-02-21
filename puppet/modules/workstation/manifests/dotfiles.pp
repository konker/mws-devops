class dotfiles ($user) {

    file { 'WORKING':
        path => '/home/$user/WORKING',
        ensure => directory,
        require => User[$captain],
        before => Exec['fetch-dotfiles'],
    }

    # clone the dotfiles repository from github
    exec { 'fetch-dotfiles':
        command => 'git clone git://github.com/konker/dotfiles.git /home/$user/WORKING/dotfiles',
        require => File['WORKING'],
        before => [ Exec['vundle'], Exec['oh-my-zsh'] ],
    }

    exec { 'vundle':
        command => "git clone http://github.com/gmarik/vundle.git /home/$user/.vim/bundle/vundle",
        require => Exec['fetch-dotfiles'],
    }

    # run VundleInstall without actually starting vim
    exec { 'vundle-install':
        command => "/usr/bin/vim +BundleInstall +qall",
        require => Exec['vundle'],
    }

    exec { 'oh-my-zsh':
        command => "git clone git://github.com/robbyrussell/oh-my-zsh.git /home/$user/.oh-my-zsh",
        require => Exec['fetch-dotfiles'],
    }

    # link dotfiles to the ones in the git repository
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
