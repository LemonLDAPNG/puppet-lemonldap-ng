# == Class: lemonldap::server
#
#   Installs LemonLDAP backend
#
# === Parameters
#
# [*do_soap*]
#   Should we configure webserver to serve SOAP-related requests? Defaults
#   to 'False'.
# [*do_ssl*]
#   Should we configure webserver to serve LLNG using SSL & HTTPS? Defaults
#   to 'False'.
# [*domain*]
#   The root domain we would setup LLNG services on top of. Beware a default
#   install would setup virtualhosts for (reload|manager|auth|test1).yourdomain
#   Defaults to 'undef'.
# [*ssl_ca_path*]
#   When 'do_ssl' is 'True', set here your custom CA path. Defaults to 'undef'.
# [*ssl_cert_path*]
#   When 'do_ssl' is 'True', set here your certificate. Make sure its CN would
#   match all your virtualhosts hostnames. Defaults to 'undef'.
# [*ssl_key_path*]
#   When 'do_ssl' is 'True', set here your certificate key. Defaults to 'undef'.
# [*webserver*]
#   Chose from 'apache' or 'nginx'. Defaults to 'apache'.
#
# === Variables
#
# === Authors
#
# Clément Oudot <clement.oudot@savoirfairelinux.com>
#

class lemonldap::server (
  Boolean $do_soap      = false,
  Boolean $do_ssl       = false,
  String $domain        = undef,
  String $ssl_ca_path   = undef,
  String $ssl_cert_path = undef,
  String $ssl_key_path  = undef,
  String $webserver     = "apache") {
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
		    do_soap => $do_soap,
		    domain  => $domain;
	    }
	}
	"nginx": {
	    class {
		lemonldap::server::webserver::nginx:
		    do_soap => $do_soap,
		    domain  => $domain;
	    }
	}
	default: {
	    fail("Module ${module_name} needs apache or nginx webserver")
	}
    }

    # Set vhost in /etc/hosts
    each($lemonldap::vars::webserver_prefixes) |$prefix| {
	host {
	    "$prefix.$domain":
		ip => $::ipaddress;
	}
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
