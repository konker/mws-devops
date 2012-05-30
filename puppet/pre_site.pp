
Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }

node default {
    class { "base": }
    class { "base::pre": }
}
