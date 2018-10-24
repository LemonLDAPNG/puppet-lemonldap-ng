# Puppet LemonLDAP::NG module

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)

## Overview

This is the puppet LemonLDAP::NG module. It can be used to install LemonLDAP::NG on a server.

## Module Description

Installation can be done on RedHat and Debian systems, alongside Apache or Nginx.

Default SSO domain can also be configured.

## Setup

Call lemonldap::server class to install LemonLDAP::NG on a node:

````
    class { 'lemonldap::server':
        do_soap   => true,
        domain    => 'example.com',
        webserver => 'apache';
    }
````
