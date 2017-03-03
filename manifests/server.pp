class lemonldap::server ($domain,$webserver) {
	# Execute OS specific actions
	case $::osfamily {
		'Debian':	{ include lemonldap::server::operatingsystem::debian($webserver) } 	
		'RedHat':	{ include lemonldap::server::operatingsystem::redhat($webserver) }
		default:
	}

	# LemonLDAP packages
	$packageslemon = ['lemonldap-ng', 'lemonldap-ng-fr-doc']

	host{'lemonldap':
		ip      => $::ipaddress,
		aliases => ["reload.$lemonldap::domain"],
	}

	package{'lemonpackages':
		name 	=> "$packageslemon",
		ensure	=> installed,
		require	=> Package['lemonpackagewebserver'],
	}

	case $webserver {
                'apache':       { include lemonldap::server::webserver::apache($webserverpath,$domain) }
                'nginx' :       { include lemonldap::server::webserver::nginx($webserverpath,$domain) }
                default:
        }

}
