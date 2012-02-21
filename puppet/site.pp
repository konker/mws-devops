$captain = 'captain'

node "base" {
    include system::secrets
    include sudo::sudo
    include ssh::sshd

    class { "server::admin": 
        user => $::captain,
        password => $system::secrets::password1,
    }
}

node "sputnik", "mothership" inherits "base" {

    class { "workstation::dotfiles":
        user => $::captain,
    }
}

