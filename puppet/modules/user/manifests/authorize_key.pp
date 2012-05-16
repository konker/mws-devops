define user::authorize_key ($user, $authorize_public_key, $key_label) {

    ssh_authorized_key { "${user}:${key_label}@morningwoodsoftware.com":
        key => $authorize_public_key,
        user => $user,
        type => 'ssh-rsa',
    }
}
