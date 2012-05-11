
class ssh::ssh {

    package { 'openssh-client':
        ensure => present,
    }

    file { 'ssh_config':
        path => '/etc/ssh/ssh_config',
        ensure => file,
        owner => 'root',
        group => 'root',
        mode => 644,
        require => Package['openssh-client'],
        source => 'puppet:///modules/ssh/ssh_config',
    }

    file { 'ssh_known_hosts':
        path => '/etc/ssh/ssh_known_hosts',
        ensure => file,
        owner => 'root',
        group => 'root',
        mode => 644,
        require => Package['openssh-client'],
    }
}
