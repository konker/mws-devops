class base::gcc {

    package { "gcc":
        ensure => present,
    }

    package { "g++":
        ensure => present,
    }

    package { "make":
        ensure => present,
    }
}

