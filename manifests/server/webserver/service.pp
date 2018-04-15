define lemonldap::server::webserver::service(
  String $service_name = $name) {
    if (! defined(Service[$service_name])) {
	service {
	    $service_name:
		enable => true,
		ensure => running;
	}
    }
}
