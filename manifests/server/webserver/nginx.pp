class lemonldap::server::webserver::nginx($do_soap = false,
					  $domain  = false) {
    lemonldap::server::webserver::service { "nginx": }

    lemonldap::server::webserver::setdomain {
	$lemonldap::vars::webserver_conf:
	    domain    => $domain,
	    notify    => Service["nginx"],
	    webserver => "nginx";
    }

    lemonldap::server::webserver::portalsoap {
	"nginx":
	    do_soap => $do_soap,
	    notify  => Service["nginx"];
    }
}
