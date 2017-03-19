class puppet-lemonldap-ng::server::webserver::nginx($domain) {
 
    $nginxconf = ['/etc/lemonldap/handler-nginx.conf','/etc/lemonldap/manager-nginx.conf', '/etc/lemonldap/portal-nginx.conf','/etc/lemonldap/test-nginx.conf' ]

    changedomain{  $nginxconf : }

    define changedomain() { 
        exec { "changedomain$name" :
              path    => ['/bin','/usr/bin'],
              command => "sed -i 's/\${domain}/$domain/g' $name ",
              onlyif  => "grep -q '{domain}' $name",
        }
    }

}
