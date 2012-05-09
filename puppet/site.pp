$admin_user = 'sysadmin'
$workstation_user = 'konker'

$public_key = 'AAAAB3NzaC1yc2EAAAABIwAAAQEAu73i+JZ/KhqdAVYCkzQEGAzh14jpGa3m3V8y/At07psIWq1bQpAnADQQkqJNsm5xgloDDlOQBeQAI4NnK1E7/aD3wkF0tDGA1S8myGhAHxGvogv5X5Ujq1wnUfF+048lioRZxcHkzULGBX5uF2PIRXX/v1My7uxzx8sgv+aQnjqv67qCAM92mNubA4U72Yzoy4ZsBsUflvTwZm2RlBlXrwdRBxQUtce/QPHJoBCvVVLElp6E0HtHuYMRVbFBAdH/D1rNvJcrM97w7WXih+Q4jOQed9jmR+VSM1arqTPtNh8J2lOWHwrriONeK823WUVHS4cNZJMhKnKYCAC8HegN2Q=='

node "base" {
    include sudo::sudo
    include ssh::sshd
    include base::user
}

node "sputnik", "mothership" inherits "base" {

    class { 'development::tools': }

    user::user { "$::admin_user": 
        user       => $::admin_user,
        groups     => ['sudo'],
        authorize_public_key => $::public_key,
    }

    user::dotfiles { "${::admin_user}_dotfiles":
        user => $::admin_user,
    }

    user::devops { "${::admin_user}_devops":
        user => $::admin_user,
    }

    user::user { "$::workstation_user": 
        user       => $::workstation_user,
        groups     => ['users'],
        authorize_public_key => $::public_key,
    }

    user::dotfiles { "${::workstation_user}_dotfiles":
        user => $::workstation_user,
    }
}
