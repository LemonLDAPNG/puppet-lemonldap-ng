class lemonldap::server($domain, $webserver) {
    include lemonldap::vars

    # Execute OS specific actions
    case $::osfamily {
	"Debian": {
	    class {
		lemonldap::server::operatingsystem::debian:
		    webserver => $webserver;
	    }
	}
	"RedHat": {
	    class {
		lemonldap::server::operatingsystem::redhat:
		    webserver => $webserver;
	    }
	}
	default: {
	    fail("Module ${module_name} is not supported on ${::operatingsystem}")
	}
    }

    # LemonLDAP packages
    package {
	[ "lemonldap-ng", "lemonldap-ng-fr-doc" ]:
	    ensure => installed,
    }

    case $webserver {
	"apache", "httpd": {
	    class {
		lemonldap::server::webserver::apache:
		    domain => $domain;
	    }
	}
	"nginx": {
	    class {
		lemonldap::server::webserver::nginx:
		    domain => $domain;
	    }
	}
	default: {
	    fail("Module ${module_name} needs apache or nginx webserver")
	}
    }

    # Set reload vhost in /etc/hosts
    host {
	"lemonldap":
	    ip           => $::ipaddress,
	    host_aliases => "reload.$domain",
    }

    # Set default domain
    exec {
	"Set LLNG Default Domain":
	    command => "sed -i 's/example\.com/$domain/g' conf/lmConf-1.js test/index.pl",
	    cwd     => "/var/lib/lemonldap-ng",
	    onlyif  => "grep example.com conf/lmConf-1.js test/index.pl",
	    path    => "/usr/bin:/bin",
	    require => Package["lemonldap-ng"],
    }
}
