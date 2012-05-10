
class ssh::ssh {

    package { 'openssh-client':
        ensure => present,
    }
}
