class puppet-lemonldap-ng::server::operatingsystem::debian($webserver) {

    if $webserver == 'nginx' {
        $packageswebserver = ['nginx','nginx-extras', 'lemonldap-ng-fastcgi-server','apt-transport-https']
    }
    elsif $webserver == 'apache' {
        $packageswebserver = ['apache2','libapache2-mod-perl2','libapache2-mod-fcgid','apt-transport-https']
    }

    file{ 'repository_debian':
        source  => 'puppet:///modules/lemonldap/debian_lemonldap-ng.list',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        path    => '/etc/apt/sources.list.d/lemonldap-ng.list',
    }

    file{ 'repository_key':
        source  => 'puppet:///modules/lemonldap/rpm-gpg-key-ow2',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        path    => '/tmp/rpm-gpg-key-ow2',
    }

    exec{ 'add_apt_key':
        command      => '/usr/bin/apt-key add /tmp/rpm-gpg-key-ow2',
        refreshonly  => true,
        subscribe    => File['repository_key'],
    }

    exec{ 'refresh_apt':
        command      => '/usr/bin/apt update',
        refreshonly  => true,
        require      => Exec['add_apt_key'],
        subscribe    => [ File['repository_key'], File['repository_debian']],
    }

    package{ $packageswebserver :
        ensure => installed,
    }

}
