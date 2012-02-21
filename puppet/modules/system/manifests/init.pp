class system::init {
    exec { "get_password":
        command => "/home/ubuntu/devops/bin/get_password",
        creates => "/home/ubuntu/devops/puppet/modules/system/manifests/secrets.pp",
    }
}
