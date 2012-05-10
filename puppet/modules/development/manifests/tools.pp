class development::tools {

    notify { "installing development::tools": }

    package { "vim-tiny":
        ensure => absent,
    }

    package { "vim":
        ensure => present,
    }

    package { "pylint":
        ensure => present,
    }
}
