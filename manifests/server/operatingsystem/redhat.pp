class lemonldap::server::operatingsystem::redhat ($webserver) {
	$apachegroup = 'apache';

	if $webserver == 'nginx' {
		$packageswebserver 			= ['nginx']
                $lemonldap::server::webserverpath       = "/etc/nginx"
	}
	elsif $webserver == 'apache' {
		$packageswebserver 			= ['httpd','mod_perl','mod_fcgid']
                $lemonldap::server::webserverpath       = "/etc/httpd"
	}

        file{'repository_redhat':
                source	=> 'puppet:///modules/lemonldap/redhat_lemonldap-ng.repo',
                owner   => 'root',
                group   => 'root',
                mode    => '0644',
		path	=> '/etc/yum.repo.d/lemonldap-ng.repo',
        }

        file{'repository_redhat_epel':
                source	=> 'puppet:///modules/lemonldap/epel.repo',
                owner   => 'root',
                group   => 'root',
                mode    => '0644',
		path	=> '/etc/yum.repo.d/epel.repo',
        }
	
	file{'repository_key':
		source  => 'puppet:///modules/lemonldap/rpm-gpg-key-ow2',
		owner   => 'root',
		group   => 'root',
		mode    => '0644',
		path    => '/tmp/rpm-gpg-key-ow2',
	}

	exec{'add_rpm_key':
		command		=> '/bin/rpm --import /tmp/rpm-gpg-key-ow2',
		refreshonly	=> true,
		subscribe	=> File['repository_key'],
	}

	exec{'refresh_yum':
		command		=> '/usr/bin/yum clean all && /usr/bin/yum makecache',
		refreshonly	=> true,
		require		=> Exec['add_rpm_key'],
		subscribe	=> [File['repository_key'], File['repository_redhat'], File['repository_redhat_epel']],
	}

	package{'lemonpackagewebserver' :
		name	=> "$packageswebserver",
		ensure  => installed,
	}
}
