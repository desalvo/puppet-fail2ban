puppet-fail2ban
======

Puppet module for fail2ban configuration.

#### Table of Contents
1. [Overview - What is the fail2ban module?](#overview)

Overview
--------

This module is intended to be used to manage the fail2ban configurations.

Parameters
----------

**Configuration**
```
class { fail2ban: }
```

* **bantime**: banning time, in seconds
* **backend**: backend to be used, defaults to 'auto'. Use 'systemd' to force using systemd.
* **action**: action used to ban, defaults to 'iptables'. Set it to 'firewallcmd-ipset' to use firewalld.
* **findtime**: the counter is set to zero if no match is found within "findtime" seconds
* **maxretry**: number of matches (i.e. value of the counter) which triggers ban action on the IP
* **jails**: hash of jails to activate, currently supported options are imap, pop3, sshd, vsftpd.
* **mailto**: mail address to send notifications
* **log_file**: the log file path or SYSLOG (default), STDOUT, STDERR
* **log_level**: the log level, level can be one of CRITICAL, ERROR, WARNING, NOTICE, INFO, DEBUG


Usage
-----

### Examples

This is a simple example to configure fail2ban with an SSH and IMAP jail.
You can override values for the given jail by specifying the parameters in the jail hash.

**Using the fail2ban ssh and imap  jails**

```fail2ban
class { 'fail2ban':
    jails  => {'sshd' => { 'maxretry' => 5 }, 'imap' => {}},
    mailto => 'root@example.com',
}
```

Contributors
------------

* https://github.com/desalvo/puppet-fail2ban/graphs/contributors

Release Notes
-------------

**1.0.0**

* Firewalld support
* Jail parameter overrides

**0.1.8**

* Fix params inheritance namespace
* New log_level parameter

**0.1.7**

* Add backend parameter to force systemd

**0.1.6**

* Puppet 4 compatibility

**0.1.5**

* Add log_file option

**0.1.4**

* Fix whois package name for RHEL  < 7

**0.1.3**

* Add whois in case of ssh jails defined

**0.1.2**

* Add bantime, findtime and maxretry parameters

**0.1.0**

* Initial version
