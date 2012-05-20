define ssh::sshkey ($name, $host, $key='', $key_file='') {
    notify { "sshkey $host":
        message => "Adding sshkey for $host",
    }

    if $key_file != '' {
        sshkey { "$name":
            type => ssh-rsa,
            key => generate('/usr/bin/cut', '-c', '9-', $key_file),
            ensure => present,
            require => Package["openssh-client"],
        }
    }
    else {
        sshkey { "$name":
            type => ssh-rsa,
            key => $key,
            ensure => present,
            require => Package["openssh-client"],
        }
    }
}
