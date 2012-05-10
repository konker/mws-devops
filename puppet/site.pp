$admin_user = 'sysadmin'
$workstation_user = 'konker'

$public_key = 'AAAAB3NzaC1yc2EAAAABIwAAAQEAu73i+JZ/KhqdAVYCkzQEGAzh14jpGa3m3V8y/At07psIWq1bQpAnADQQkqJNsm5xgloDDlOQBeQAI4NnK1E7/aD3wkF0tDGA1S8myGhAHxGvogv5X5Ujq1wnUfF+048lioRZxcHkzULGBX5uF2PIRXX/v1My7uxzx8sgv+aQnjqv67qCAM92mNubA4U72Yzoy4ZsBsUflvTwZm2RlBlXrwdRBxQUtce/QPHJoBCvVVLElp6E0HtHuYMRVbFBAdH/D1rNvJcrM97w7WXih+Q4jOQed9jmR+VSM1arqTPtNh8J2lOWHwrriONeK823WUVHS4cNZJMhKnKYCAC8HegN2Q=='

$hostkeys = [
    ['github.com',
     'github.com,207.97.227.239',
     'AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==']
]

node "base" {
    include sudo::sudo
    include ssh::sshd
    include base::user
}

node "sputnik", "mothership" inherits "base" {

    include ssh::ssh
    ssh::sshkey { $::hostkeys[0][0]:
       name   => $::hostkeys[0][0],
       host   => $::hostkeys[0][1],
       key    => $::hostkeys[0][2],
       before => User::user[$::admin_user],
    }

    include development::tools

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
