define ssh::sshkey ($host, $key) {
    notify { "sshkey $host":
        message => "Adding sshkey for $host",
    }

    sshkey { "$host":
        type => ssh-rsa,
        key => $key,
        ensure => present,
        require => Package["openssh-client"],
    }
}
