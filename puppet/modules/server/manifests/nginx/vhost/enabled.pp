
define server::nginx::vhost::enabled($param_server_name, up='true') {
    # file sites-available/server_name.conf
        # check exists
    # if up == 'true'
        # file link -> sites-enabled/server_name.conf
    # else
        # file delete link sites-enabled/server_name.conf

}
