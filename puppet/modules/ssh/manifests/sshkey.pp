define ssh::sshkey ($name, $host, $key) {
    notify { "sshkey $host":
        message => "Adding sshkey for $host",
    }

    sshkey { "$name":
        type => ssh-rsa,
        key => $key,
        ensure => present,
        require => Package["openssh-client"],
    }
}
