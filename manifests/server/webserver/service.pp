define lemonldap::server::webserver::service($service_name = $name) {
    if (! defined(Service[$service_name])) {
	service {
	    $service_name:
		ensure => running;
	}
    }
}
