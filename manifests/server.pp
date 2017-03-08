class lemonldap::server($domain,$webserver) {

    # Execute OS specific actions
    case $::osfamily {
        'Debian': { 
             class { 'lemonldap::server::operatingsystem::debian' : webserver => $webserver }
         }
        'RedHat': { 
             class { "lemonldap::server::operatingsystem::redhat" : webserver => $webserver }
         }
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
        'apache': { 
              class { "lemonldap::server::webserver::apache" : domain => $domain } 
        }
        'nginx' : { 
              class { "lemonldap::server::webserver::nginx" : domain => $domain }
        }
        default: { fail("Module ${module_name} needs apache or nginx webserver") }
    }

    # Set reload vhost in /etc/hosts
    host{'lemonldap':
        ip      => $::ipaddress,
        host_aliases => "reload.$domain",
    }

    # Change default domain
    exec{ 'change-default-domain':
        command => 'sed -i \'s/example\.com/${domain}/g\' /etc/lemonldap-ng/* /var/lib/lemonldap-ng/conf/lmConf-1.js /var/lib/lemonldap-ng/test/index.pl',
        path    => ['/bin', '/usr/bin'],
    }

}
