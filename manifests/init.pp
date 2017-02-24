# == Class: fail2ban
#
# Module for fail2ban configuration.
#
# === Parameters
#
# [*bantime*]
#   Banning time
#
# [*findtime*]
#   The counter is set to zero if no match is found within "findtime" seconds 
#
# [*maxretry*]
#   Number of matches (i.e. value of the counter) which triggers ban action on the IP
#
# [*jails*]
#   Hash of jails to activate. Currently supported options are imap, pop3, sshd, vsftpd.
#   The list is an hash of jails. You can also specify different parameters for each jail.
#   Example:
#   { 'sshd' => { 'maxretry' => 5 }, 'imap' => {} }
#
# [*backend*]
#   Backend to use, defaults to 'auto'
#
# [*action*]
#   Ban action to be used, deafults to iptables
#
# [*mailto*]
#   The mail address where to send notifications
#
# [*log_file*]
#   The log file path or SYSLOG (default), STDOUT, STDERR
#
# [*log_level*]
#   The log level. Levels: CRITICAL, ERROR, WARNING, NOTICE, INFO, DEBUG
#
# === Examples
#
#  class { fail2ban:
#    jails  => ['ssh'],
#    mailto => 'root@example.com',
#  }
#
# === Authors
#
# Alessandro De Salvo <Alessandro.DeSalvo@roma1.infn.it>
#
# === Copyright
#
# Copyright 2014 Alessandro De Salvo
#
class fail2ban (
  $jails     = {},
  $bantime   = $::fail2ban::params::bantime,
  $backend   = $::fail2ban::params::backend,
  $action    = $::fail2ban::params::action,
  $findtime  = $::fail2ban::params::findtime,
  $mailto    = undef,
  $maxretry  = $::fail2ban::params::maxretry,
  $ignoreip  = $::fail2ban::params::ignoreip,
  $log_file  = $::fail2ban::params::log_file,
  $log_level = $::fail2ban::params::log_level,
) inherits fail2ban::params {
    file { $fail2ban::params::config_file:
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('fail2ban/fail2ban.local.erb'),
        require => Package[$fail2ban::params::package],
        notify  => Service[$fail2ban::params::service]
    }
    file { $fail2ban::params::jail_file:
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('fail2ban/jail.local.erb'),
        require => Package[$fail2ban::params::package],
        notify  => Service[$fail2ban::params::service]
    }
    package { $fail2ban::params::package: ensure => latest }
    if ($backend == 'systemd') {
        package { $fail2ban::params::package_systemd: ensure => latest }
        service { $fail2ban::params::service:
            ensure => running,
            enable => true,
            hasrestart => true,
            provider => systemd,
            require => [Package[$fail2ban::params::package],Package[$fail2ban::params::package_systemd]]
        }
    } else {
        service { $fail2ban::params::service:
            ensure => running,
            enable => true,
            hasrestart => true,
            require => Package[$fail2ban::params::package]
        }
    }
    if (has_key($jails,'sshd') {
        package { $fail2ban::params::whois: ensure => latest }
    }
}
