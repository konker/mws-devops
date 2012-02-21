class server::base ($user, $password='foo') {
    user { "$user":
        ensure => present,
        groups => ['admin'],
        home => "/home/$user",
        shell => '/bin/zsh',
        password => $password,
        managehome => true,
        before => File['.ssh'],
    }

    file { '.ssh':
        path => "/home/$user/.ssh",
        ensure => directory,
        owner => $user,
        group => $user,
        mode => 600,
        before => Ssh_authorized_key['devops@morningwoodsoftware.com'],
    }

    ssh_authorized_key { 'devops@morningwoodsoftware.com':
        key => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAu73i+JZ/KhqdAVYCkzQEGAzh14jpGa3m3V8y/At07psIWq1bQpAnADQQkqJNsm5xgloDDlOQBeQAI4NnK1E7/aD3wkF0tDGA1S8myGhAHxGvogv5X5Ujq1wnUfF+048lioRZxcHkzULGBX5uF2PIRXX/v1My7uxzx8sgv+aQnjqv67qCAM92mNubA4U72Yzoy4ZsBsUflvTwZm2RlBlXrwdRBxQUtce/QPHJoBCvVVLElp6E0HtHuYMRVbFBAdH/D1rNvJcrM97w7WXih+Q4jOQed9jmR+VSM1arqTPtNh8J2lOWHwrriONeK823WUVHS4cNZJMhKnKYCAC8HegN2Q==',
        user => $user,
        type => 'ssh-rsa',
        before => Exec['ssh-keygen'],
    }

    # create a rsa key pair
    exec { 'ssh-keygen':
        command => "/usr/bin/ssh-keygen -q -f /home/$user/.ssh/id_rsa -t rsa -N ''",
        creates => "/home/$user/.ssh/id_rsa",
    }

}

