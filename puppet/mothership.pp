class { 'sudo::sudo':}
class { 'ssh::sshd':}

class { 'server::base': 
    user => $captain,
    password => $password,
}

class { 'workstation::dotfiles':
    user => $captain,
}
