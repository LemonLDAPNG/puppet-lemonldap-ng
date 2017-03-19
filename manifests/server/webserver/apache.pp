class puppet-lemonldap-ng::server::webserver::apache($domain) {
    
    $apacheconf = ['/etc/lemonldap-ng/handler-apache2.conf','/etc/lemonldap-ng/manager-apache2.conf','/etc/lemonldap-ng/portal-apache2.conf','/etc/lemonldap-ng/test-apache2.conf']
  
    changedomain{ $apacheconf : }

    define changedomain() {
	exec { "changedomain$name" :
              path    => ['/usr/bin','/bin'],
              command => "sed -i 's/example\.com/$domain/g' $name ",
              onlyif  => "grep -q 'example.com' $name",
              require =>  Exec[ 'change-default-domain'],
        }
    }


}
