class lemonldap::server($domain,$webserver) {

    # Execute OS specific actions
    case $::osfamily {
        'Debian': { include lemonldap::server::operatingsystem::debian($webserver) }
        'RedHat': { include lemonldap::server::operatingsystem::redhat($webserver) }
        default: { fail("Module ${module_name} is not supported on ${::operatingsystem}") }
    }

    # LemonLDAP packages
    $packageslemon = ['lemonldap-ng', 'lemonldap-ng-fr-doc']

    package{'lemonpackages':
        name     => "$packageslemon",
        ensure    => installed,
        require    => Package['lemonpackagewebserver'],
    }

    case $webserver {
        'apache': { include lemonldap::server::webserver::apache($domain) }
        'nginx' : { include lemonldap::server::webserver::nginx($domain) }
        default: { fail("Module ${module_name} needs apache or nginx webserver") }
    }

    # Set reload vhost in /etc/hosts
    host{'lemonldap':
        ip      => $::ipaddress,
        aliases => ["reload.$lemonldap::domain"],
    }

    # Change default domain
    exec{ 'change-default-domain':
        command => "sed -i 's/example\.com/${domain}/g' /etc/lemonldap-ng/* /var/lib/lemonldap-ng/conf/lmConf-1.js /var/lib/lemonldap-ng/test/index.pl",
        path    => ['/bin', '/usr/bin'],
    }

}
