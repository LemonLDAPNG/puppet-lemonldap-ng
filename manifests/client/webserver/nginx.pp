class lemonldap::client::webserver::nginx ($name,$ip) { 
	file { "/etc/nginx/site-$name.conf" : 
		content=> template('lemonldap/nginx-client-template.erb'),
		subscribe => Service{'nginx'],
	}	
}
