define ssh::sshkey ($name, $host, $key='', $keyfile='') {
    notify { "sshkey $host":
        message => "Adding sshkey for $host",
    }

    if $keyfile == '' {
        if $key == '' {
            notify { "sshkey failed for ${host}: no key or keyfile given": }
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
    else {
        sshkey { "$name":
            type => ssh-rsa,
            #key => generate('/usr/bin/cut', '-c', '9-', $keyfile),
            key => file($keyfile, '/dev/null'),
            ensure => present,
            require => Package["openssh-client"],
        }
    }
}
