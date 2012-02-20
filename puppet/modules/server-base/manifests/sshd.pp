class sshd {
    package { 'openssh-server':
        ensure => present,
        before => File['sshd_config'],
    }

    file { 'sshd_config':
        path => '/etc/ssh/sshd_config',
        ensure => file,
        owner => 'root',
        group => 'root',
        mode => 600,
        source => 'puppet:///modules/ssh/sshd_config',
    }

    service { 'sshd':
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => true,
        subscribe => File['sshd_config'],
    }
}
