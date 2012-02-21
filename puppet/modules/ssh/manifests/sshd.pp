class server::sshd {

    package { 'openssh-server':
        ensure => present,
    }

    file { 'sshd_config':
        path => '/etc/ssh/sshd_config',
        ensure => file,
        owner => 'root',
        group => 'root',
        mode => 600,
        require => Package['openssh-server'],
        source => 'puppet:///modules/server/sshd_config',
    }

    service { 'ssh':
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => true,
        subscribe => File['sshd_config'],
    }
}
