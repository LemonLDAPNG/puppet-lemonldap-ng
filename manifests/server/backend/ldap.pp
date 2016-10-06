class lemonldap::server::backend::ldap ( ) {

	define backendldap($host,$port,$base,$user,$pwd,$attrs) {

		exec{'cli_set_ldap_host':
			command		=> "/usr/share/lemonldap-ng/bin/lemonldap-ng-cli set ldapServer $host",
			unless		=> "/usr/share/lemonldap-ng/bin/lemonldap-ng-cli get ldapServer | grep -q $host",
		}
		exec{'cli_set_ldap_base':
			command		=> "/usr/share/lemonldap-ng/bin/lemonldap-ng-cli set ldapBase $base",
			unless		=> "/usr/share/lemonldap-ng/bin/lemonldap-ng-cli get ldapBase | grep -q $base",
		}
		exec{'cli_set_ldap_port':
			command		=> "/usr/share/lemonldap-ng/bin/lemonldap-ng-cli set ldapPort $port",
			unless		=> "/usr/share/lemonldap-ng/bin/lemonldap-ng-cli get ldapPort | grep -q $port",
		}
		exec{'cli_set_ldap_user':
			command		=> "/usr/share/lemonldap-ng/bin/lemonldap-ng-cli set managerDn $user",
			unless		=> "/usr/share/lemonldap-ng/bin/lemonldap-ng-cli get managerDn | grep -q $user",
		}
		exec{'cli_set_ldap_pwd':
			command		=> "/usr/share/lemonldap-ng/bin/lemonldap-ng-cli set managerPassword $pwd",
			unless		=> "/usr/share/lemonldap-ng/bin/lemonldap-ng-cli get managerPassword | grep -q $pwd",
		}

		$attrs.each |$attr| {
			exec{"cli_set_ldap_attrs_$attr":
				command		=> "/usr/share/lemonldap-ng/bin/lemonldap-ng-cli addkey ldapExportedVars $attr $attrs[$attr]",
				unless		=> "/usr/share/lemonldap-ng/bin/lemonldap-ng-cli get ldapExportedVars/$attr | grep -q \"ldapExportedVars/$attr = $attrs[$attr]\"",
			}
		}

	}

}
