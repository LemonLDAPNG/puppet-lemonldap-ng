class lemonldap::server::operatingsystem::redhat($webserver = "apache") {
    $gpg_pubkey_id = $lemonldap::vars::gpg_pubkey_id
    case $webserver {
	"nginx": {
	    $packageswebserver = [ "nginx", "lemonldap-ng-fastcgi-server", "perl-LWP-Protocol-https" ]

	    Package["nginx"]
		-> Service["nginx"]
	}
	"apache", "httpd": {
	    $packageswebserver = [ "httpd", "mod_perl", "mod_fcgid", "perl-LWP-Protocol-https" ]

	    Package["httpd"]
		-> Service["httpd"]
	}
	default: {
	    fail("Invalid webserver '$webserver', please use nginx, apache or httpd")
	}
    }

    file {
	"Install LLNG Enterprise Linux Repository":
	    group  => "root",
	    mode   => "0644",
	    notify => Exec["Refresh Packages Cache"],
	    owner  => "root",
	    path   => "/etc/yum.repos.d/lemonldap-ng.repo",
	    source => "puppet:///modules/lemonldap/redhat_lemonldap-ng.repo";
	"Install LLNG Repository Key":
	    group  => "root",
	    mode   => "0644",
	    owner  => "root",
	    path   => "/etc/pki/rpm-gpg/RPM-GPG-KEY-OW2",
	    source => "puppet:///modules/lemonldap/rpm-gpg-key-ow2";
    }

    package {
	"epel-release":
	    ensure => present;
    }

    exec {
	"Import LLNG RPM Key":
	    command     => "rpm --import RPM-GPG-KEY-OW2",
	    cwd         => "/etc/pki/rpm-gpg",
	    path        => "/usr/sbin:/usr/bin:/sbin:/bin",
	    require     => File["Install LLNG Repository Key"],
	    unless      => "rpm -q gpg-pubkey --qf '%{VERSION}\n' | grep -i $gpg_pubkey_id";
	"Refresh Packages Cache":
	    command     => "yum clean all && yum makecache",
	    path        => "/usr/sbin:/usr/bin:/sbin:/bin",
	    refreshonly => true,
	    require     => [
		    Exec["Import LLNG RPM Key"],
		    Package["epel-release"]
		];
    }

    if ($packagewebserver != false) {
	package {
	    $packageswebserver:
		ensure  => present,
		require => Exec["Refresh Packages Cache"];
	}
    }
}
