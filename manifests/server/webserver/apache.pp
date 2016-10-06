class lemonldap::server::webserver::apache($webserverpath,$domain) {

	augeas{"handlerapache":
		context	=> '/files/etc/lemonldap/handler-apache2.conf',
		changes => [
			'set "ErrorDocument 403" "http://auth.$domain/?lmError=403"',
			'set "ErrorDocument 500" "http://auth.$domain/?lmError=500"',
			'set "ErrorDocument 503" "http://auth.$domain/?lmError=503"',
			'set ServerName reload.$domain',
			],
		onlyif	=> 'values "ErrorDocument 403" != "http://auth.$domain/?lmError=403"',
	}

	augeas{"managerapache":
		context	=> '/files/etc/lemonldap/manager-apache2.conf',
		changes => 'set ServerName manager.sfl.local',
		onlyif	=> 'values "ServerName" != "manager.sfl.local"',
	}
	
	augeas{"portalapache":
		context	=> '/files/etc/lemonldap/portal-apache2.conf',
		changes	=> 'set ServerName portal.sfl.local',
		onlyif	=> 'values "ServerName" != "portal.sfl.local"',
	}

	augeas{"testapache":
		context	=> '/files/etc/lemonldap/test-apache2.conf',
		changes	=> [
			'set ServerName test1.sfl.local',
			'set ServerAlias test2.sfl.local',
			]
		onlyif	=> 'values "ServerName" != "test1.sfl.local"',
	}
	
}
