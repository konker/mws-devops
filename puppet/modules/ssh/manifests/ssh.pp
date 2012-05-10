
class ssh::ssh {

    package { 'openssh-client':
        ensure => present,
    }

    file { 'ssh_config':
        path => '/etc/ssh/ssh_config',
        ensure => file,
        owner => 'root',
        group => 'root',
        mode => 600,
        require => Package['openssh-client'],
        source => 'puppet:///modules/ssh/ssh_config',
    }
}
