define ssh::sshkey ($host, $key) {
    sshkey { "$host":
        type => ssh-rsa,
        key => $key,
        ensure => present,
        require => Package["openssh-client"],
    }
}
