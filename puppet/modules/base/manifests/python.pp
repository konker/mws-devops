class base::python {

    package { "python":
        ensure => present,
    }

    package { "python-dev":
        ensure => present,
    }

    package { "python-pip":
        ensure => present,
    }
}

