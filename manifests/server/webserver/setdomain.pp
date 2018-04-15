define lemonldap::server::webserver::setdomain($domain    = false,
					       $webserver = "apache") {
    if ($domain != false) {
	exec {
	    "Set LLNG $name Domain" :
		command => "sed -i 's/example\.com/$domain/g' ${name}-${webserver}*.conf",
		cwd     => "/etc/lemonldap-ng",
		onlyif  => "grep example.com ${name}-${webserver}*.conf",
		path    => "/usr/bin:/bin",
		require =>  Exec["Set LLNG Default Domain"];
	}
    }
}
