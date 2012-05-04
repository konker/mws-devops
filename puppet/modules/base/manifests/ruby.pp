class base::ruby {

    package { "ruby1.9":
        ensure => present,
    }

    package { "ruby1.9*-dev":
        ensure => present,
    }

    package { "rubygems1.9":
        ensure => present,
    }
}

