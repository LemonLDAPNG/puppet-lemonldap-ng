class lemonldap::server::webserver::nginx($domain) {

    augeas{ "handlernginx":
        context => '/files/etc/lemonldap/handler-nginx.conf',
        changes => "set server_name reload.$domain",
        onlyif  => "values \"server_name\" != \"reload.$domain\"",
    }

    augeas{ "managernginx":
        context => '/files/etc/lemonldap/manager-nginx.conf',
        changes => "set server_name manager.$domain",
        onlyif  => "values \"server_name\" != \"manager.$domain\"",
    }

    augeas{ "portalnginx":
        context => '/files/etc/lemonldap/portal-nginx.conf',
        changes => "set server_name portal.$domain",
        onlyif  => "values \"server_name\" != \"portal.$domain\"",
    }

    augeas{"testnginx":
        context => '/files/etc/lemonldap/test-nginx.conf',
        changes => "set server_name \"test1.$domain test2.$domain\"",
        onlyif  => "values \"server_name\" != \"test1.$domain test2.$domain\"",
    }

}
