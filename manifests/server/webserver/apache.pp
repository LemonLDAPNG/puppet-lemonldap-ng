class lemonldap::server::webserver::apache($domain) {

    augeas{ "handlerapache":
        context => '/files/etc/lemonldap/handler-apache2.conf',
        changes => [
            'set "ErrorDocument 403" "http://auth.$domain/?lmError=403"',
            'set "ErrorDocument 500" "http://auth.$domain/?lmError=500"',
            'set "ErrorDocument 503" "http://auth.$domain/?lmError=503"',
            'set ServerName reload.$domain',
            ],
        onlyif  => 'values "ErrorDocument 403" != "http://auth.$domain/?lmError=403"',
    }

    augeas{ "managerapache":
        context => '/files/etc/lemonldap/manager-apache2.conf',
        changes => "set ServerName manager.$domain",
        onlyif  => "values \"ServerName\" != \"manager.$domain\"",
    }

    augeas{ "portalapache":
        context => '/files/etc/lemonldap/portal-apache2.conf',
        changes => "set ServerName portal.$domain",
        onlyif  => "values \"ServerName\" != \"portal.$domain\"",
    }

    augeas{ "testapache":
        context => '/files/etc/lemonldap/test-apache2.conf',
        changes => [
            "set ServerName test1.$domain",
            "set ServerAlias test2.$domain",
            ],
        onlyif  => "values \"ServerName\" != \"test1.$domain\"",
    }

}
