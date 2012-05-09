class development::tools {
    package { "vim":
        ensure => present,
    }

    package { "pylint":
        ensure => present,
    }
}
