# == Class: lemonldap::vars
#
# === Parameters
#
# === Variables
#
# === Authors
#
# Clément Oudot <clement.oudot@savoirfairelinux.com>
#

class lemonldap::vars {
    $gpg_pubkey_id      = "81F18E7A"
    $webserver_conf     = [ "handler", "manager", "portal", "test" ]
    $webserver_prefixes = [ "reload", "manager", "auth", "test1" ]
}
