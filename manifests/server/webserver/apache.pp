class lemonldap::server::webserver::apache($domain) {
    lemonldap::server::webserver::setdomain { $lemonldap::vars::webserver_conf: }
}
