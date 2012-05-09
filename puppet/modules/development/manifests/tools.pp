class development::tools {

    notify {
        message => "development::tools",
    }

    package { "vim":
        ensure => present,
    }

    package { "pylint":
        ensure => present,
    }
}
