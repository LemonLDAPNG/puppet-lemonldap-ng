class lemonldap::config {

	define authbackend($type) {
		exec{'define_auth_backend':
			command => "/usr/share/lemonldap-ng/bin/lemonldap-ng-cli -yes 1 set authentication $type",
			unless  => "/usr/share/lemonldap-ng/bin/lemonldap-ng-cli get authentication | grep -q $type",
		}
	}
	define userbackend($type) {
		exec{'define_user_backend':
			command => "/usr/share/lemonldap-ng/bin/lemonldap-ng-cli -yes 1 set userDB $type",
			unless  => "/usr/share/lemonldap-ng/bin/lemonldap-ng-cli get userDB | grep -q $type",
		}
	}
	define pwdbackend($type) {
		exec{'define_pwd_backend':
			command => "/usr/share/lemonldap-ng/bin/lemonldap-ng-cli -yes 1 set passwordDB $type",
			unless  => "/usr/share/lemonldap-ng/bin/lemonldap-ng-cli get passwordDB | grep -q $type",
		}
	}
	define domainsso($name) {
		exec{'define_domain':
			command => "/usr/share/lemonldap-ng/bin/lemonldap-ng-cli -yes 1 set domain $name",
			unless  => "/usr/share/lemonldap-ng/bin/lemonldap-ng-cli get domain | grep -q $name",
		}
	}

	define rule (name , vhost, motif, rule) { 
		tag => $vhost

	}

	define header (name,expr) {
		tag => 
	}

	define configreverse($name, $ip) {
		

	} 

	# Rules est un tableau de tableau de règle contenant commentaire/motif et règles
	define vhost($name,$aliases,$enablehttps,$port,$maintenance ) {
		# $name : nom du vhost (URL)
		# alias : vhost aliases
		<<| @Rule tag => |>>
	}

}
