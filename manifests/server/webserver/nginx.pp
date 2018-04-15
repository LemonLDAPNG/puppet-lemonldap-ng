class lemonldap::server::webserver::nginx($domain) {
    lemonldap::server::webserver::setdomain {
	$lemonldap::vars::webserver_conf:
	    webserver => "nginx";
    }
}
