define lemonldap::server::webserver::portalsoap($do_soap   = false,
						$webserver = $name) {
    if ($webserver == "apache") {
	$set23 = $do_soap ? {
		true    => "granted",
		default => "denied"
	    }
	$match23 = $do_soap ? {
		true    => "denied",
		default => "granted"
	    }
	$set22 = $do_soap ? {
		true    => "Allow",
		default => "Deny"
	    }
	$match22 = $do_soap ? {
		true    => "Deny",
		default => "Allow"
	    }
	exec {
	    "Set LLNG SOAP Portal Configuration (Apache <2.3)" :
		command => "sed -i 's/${match22} from all.*/${set22} from all/g' portal-${webserver}*.conf",
		cwd     => "/etc/lemonldap-ng",
		onlyif  => "grep '${match22} from all' portal-${webserver}*.conf",
		path    => "/usr/bin:/bin",
		require =>  Exec["Set LLNG Default Domain"];
	    "Set LLNG SOAP Portal Configuration (Apache >=2.3)" :
		command => "sed -i 's/Require all ${match23}.*/Require all ${set23}/g' portal-${webserver}*.conf",
		cwd     => "/etc/lemonldap-ng",
		onlyif  => "grep 'Require all ${match23}' portal-${webserver}*.conf",
		path    => "/usr/bin:/bin",
		require =>  Exec["Set LLNG Default Domain"];
	}
    } else {
	$setngx = $do_soap ? {
		true    => "allow",
		default => "deny"
	    }
	$matchngx = $do_soap ? {
		true    => "deny",
		default => "allow"
	    }
	exec {
	    "Set LLNG SOAP Portal Configuration (Nginx)" :
		command => "sed -i 's/${matchngx} all.*/${setngx} all;/g' portal-${webserver}*.conf",
		cwd     => "/etc/lemonldap-ng",
		onlyif  => "grep '${matchngx} all' portal-${webserver}*.conf",
		path    => "/usr/bin:/bin",
		require =>  Exec["Set LLNG Default Domain"];
	}
    }
}
