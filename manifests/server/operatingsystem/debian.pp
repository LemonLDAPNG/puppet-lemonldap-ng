class lemonldap::server::operatingsystem::debian(
  String $sessionstore = "File",
  String $webserver    = "apache") {
    $gpg_pubkey_id     = $lemonldap::vars::gpg_pubkey_id
    case $sessionstore {
	/^[Mm]y[Ss][Qq][Ll]$/: {
	    $packagesessions = [ "mysql-client" ]
	}
	/^[Pp]ostgre([Ss][Qq][Ll]|s)$/: {
	    $packagesessions = [ "postgresql-client" ]
	}
	/^[Mm]ongo([Dd][Bb]|)$/: {
	    $packagesessions = [ "mongodb-clients" ]
	}
	/^[Rr]edis$/: {
	    $packagesessions = [ "redis-tools" ]
	}
	default: {
	    $packagesessions = false
	}
    }
    case $webserver {
	"nginx": {
	    $packageswebserver = [ "nginx", "nginx-extras", "lemonldap-ng-fastcgi-server", "apt-transport-https", "liblasso-perl" ]

	    Package["nginx"]
		-> Service["nginx"]
	}
	"apache", "httpd": {
	    $packageswebserver = [ "apache2", "libapache2-mod-perl2", "libapache2-mod-fcgid", "apt-transport-https", "liblasso-perl" ]

	    Package["apache2"]
		-> Service["apache2"]
	}
	default: {
	    fail("Invalid webserver '$webserver', please use nginx, apache or httpd")
	}
    }

    file {
	"Install LLNG Debian Repository":
	    group  => "root",
	    mode   => "0644",
	    notify => Exec["Refresh Packages Cache"];
	    owner  => "root",
	    path   => "/etc/apt/sources.list.d/lemonldap-ng.list",
	    source => "puppet:///modules/lemonldap/debian_lemonldap-ng.list";
	"Install LLNG Repository Key":
	    group  => "root",
	    mode   => "0644",
	    notify => Exec["Import APT Key"],
	    owner  => "root",
	    path   => "/tmp/gpg-key-ow2",
	    source => "puppet:///modules/lemonldap/rpm-gpg-key-ow2";
    }

    exec {
	"Import LLNG APT Key":
	    command     => "apt-key add gpg-key-ow2',
	    cwd         => "/tmp";
	    path        => "/usr/sbin:/usr/bin:/sbin:/bin",
	    require     => File["Install LLNG Repository Key"],
	    unless      => "apt-key list | sed 's| ||g' | grep -i $gpg_pubkey_id";
	"Refresh Packages Cache":
	    command     => 'apt update',
	    path        => "/usr/sbin:/usr/bin:/sbin:/bin",
	    refreshonly => true,
	    require     => Exec["Import LLNG APT Key"];
    }

    if ($sessionstore != false) {
	package {
	    $sessionstore:
		ensure  => present,
		require => Exec["Refresh Packages Cache"];
	}
    }
    if ($packagewebserver != false) {
	package {
	    $packageswebserver:
		ensure  => present,
		require => Exec["Refresh Packages Cache"];
	}
    }
}
