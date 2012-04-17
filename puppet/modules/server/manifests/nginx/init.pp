#
# doc
#

class server::nginx {
    $param_nginx_user = $::nginx_user ? {
        undef   => 'www-data',
        default => $::nginx_user
    }

    $param_nginx_worker_processes = $::nginx_worker_processes ? {
        undef   => '2',
        default => $::nginx_worker_processes
    }

    $param_nginx_worker_connections = $::nginx_worker_connections ? {
        undef   => '1024',
        default => $::nginx_worker_connections
    }

    package { 'nginx':
        ensure => present,
    }

    service { 'nginx':
        ensure     => running,
        enable     => true,
        hasrestart => true,
        require    => File['/etc/nginx/nginx.conf'],
        restart    => '/etc/init.d/nginx reload'
    }

    file { '/etc/nginx/nginx.conf':
        ensure  => present,
        mode    => '0644',
        owner   => 'root',
        group   => 'root',
        content => template('server/nginx/nginx.conf.erb'),
        notify  => Service['nginx'],
        require => Package['nginx'],
    }

    file { '/etc/nginx/conf.d/mime.types':
        ensure  => present,
        mode    => '0644',
        owner   => 'root',
        group   => 'root',
        content => template('server/nginx/mime.types.erb'),
        notify  => Service['nginx'],
        require => Package['nginx'],
    }

    file { '/etc/nginx/conf.d/gzip.conf':
        ensure  => present,
        mode    => '0644',
        owner   => 'root',
        group   => 'root',
        content => template('server/nginx/gzip.conf.erb'),
        notify  => Service['nginx'],
        require => Package['nginx'],
    }

}
