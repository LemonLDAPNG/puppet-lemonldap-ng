class lemonldap::server::operatingsystem::debian ($webserver) {
#	$packagesdependency = 
#['libapache-session-perl','libnet-ldap-perl','libcache-cache-perl','libdbi-perl','perl-modules','libwww-perl','libcache-cache-perl','libxml-simple-perl','libsoap-lite-perl','libhtml-template-perl','libregexp-assemble-perl','libregexp-common-perl','libjs-jquery','libxml-libxml-perl','libcrypt-rijndael-perl','libio-string-perl','libxml-libxslt-perl','libconfig-inifiles-perl','libjson-perl','libstring-random-perl','libemail-date-format-perl','libmime-lite-perl','libcrypt-openssl-rsa-perl','libdigest-hmac-perl','libdigest-sha-perl','libclone-perl','libauthen-sasl-perl','libnet-cidr-lite-perl','libcrypt-openssl-x509-perl','libauthcas-perl','libtest-pod-perl','libtest-mockobject-perl','libauthen-captcha-perl','libnet-openid-consumer-perl','libnet-openid-server-perl','libunicode-string-perl','libconvert-pem-perl','libmoose-perl','libplack-perl']

	$apachegroup = 'www-data';

	if $webserver == 'nginx' {
		$packageswebserver 			= ['nginx','nginx-extras']
		$lemonldap::server::webserverpath	= "/etc/nginx"
	}
	elsif $webserver == 'apache' {
		$packageswebserver 			= ['apache2','libapache2-mod-perl2','libapache2-mod-fcgid']
		$lemonldap::server::webserverpath	= "/etc/apache2"
	}

	file{'repository_debian':
		source 	=> 'puppet:///modules/lemonldap/debian_lemonldap-ng.list',
		owner   => 'root',
    		group   => 'root',
		mode    => '0644',
		path	=> '/etc/apt/sources.list.d/lemonldap-ng.list',
	}

	file{'repository_key':
		source 	=> 'puppet:///modules/lemonldap/rpm-gpg-key-ow2',
		owner   => 'root',
    		group   => 'root',
		mode    => '0644',
		path	=> '/tmp/rpm-gpg-key-ow2',
	}

	exec{'add_apt_key':
		command 	=> '/usr/bin/apt-key add /tmp/rpm-gpg-key-ow2',
		refreshonly	=> true,
                subscribe       => File['repository_key'],
	}

	exec{'refresh_apt':
		command		=> '/usr/bin/apt update',
		refreshonly	=> true,
                require         => Exec['add_apt_key'],
                subscribe       => [ File['repository_key'], File['repository_debian']],
	}
	
        package{'lemonpackagewebserver' :
                name    => "$packageswebserver",
                ensure  => installed,
        }


}
