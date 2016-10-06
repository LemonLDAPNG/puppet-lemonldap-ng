class lemonldap::server::webserver::nginx($webserverpath,$domain) {

	augeas{"handlernginx":
                context => '/files/etc/lemonldap/handler-nginx.conf',
                changes => 'set server_name reload.sfl.local',
                onlyif  => 'values "server_name" != "reload.sfl.local"',
        }

        augeas{"managernginx":
                context => '/files/etc/lemonldap/manager-nginx.conf',
                changes => 'set server_name manager.sfl.local',
                onlyif  => 'values "server_name" != "manager.sfl.local"',
        }

        augeas{"portalnginx":
                context => '/files/etc/lemonldap/portal-nginx.conf',
                changes => 'set server_name portal.sfl.local',
                onlyif  => 'values "server_name" != "portal.sfl.local"',
        }

        augeas{"testnginx":
                context => '/files/etc/lemonldap/test-nginx.conf',
                changes => 'set server_name "test1.sfl.local test2.sfl.local"',
                onlyif  => 'values "server_name" != "test1.sfl.local test2.sfl.local"',
	}
}
