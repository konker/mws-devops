
class base::bin {
    file { "exec-as":
        path   => '/usr/bin/exec-as',
        ensure => file,
        source => 'puppet:///modules/base/bin/exec-as',
        mode   => 755,
        owner  => 'root',
        group  => 'root',
    }
}
