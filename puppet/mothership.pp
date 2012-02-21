$captain = 'captain'

class { 'sudo::sudo':}
class { 'ssh::sshd':}

class { 'server::base': 
    user => $captain,
    password => $password,
}

class { 'workstations::dotfiles':
    user => $captain,
}
