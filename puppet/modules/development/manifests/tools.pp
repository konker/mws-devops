class development::tools {

    notify { "installing development::tools": }

    package { "vim":
        ensure => present,
    }

    package { "pylint":
        ensure => present,
    }
}
