$captain = 'captain'

node "base" {
    class { 'sudo::sudo':}
    class { 'ssh::sshd':}

    class { "server::base": 
        user => $::captain,
        password => $::password,
    }
}

node "sputnik", "mothership" inherits "base" {

    class { "workstation::dotfiles":
        user => $::captain,
    }
}

