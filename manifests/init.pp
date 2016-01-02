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
#   List of jails to activate. Currently supported options are imap, pop3, ssh, vsftpd
#
# [*backend*]
#   Backend to use, defaults to 'auto'
#
# [*mailto*]
#   The mail address where to send notifications
#
# [*log_file*]
#   The log file path or SYSLOG (default), STDOUT, STDERR
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
  $jails    = [],
  $bantime  = undef,
  $backend  = undef,
  $findtime = undef,
  $mailto   = undef,
  $maxretry = undef,
  $log_file = $::fail2ban::params::log_file,
) inherits params {
    if ($bantime)  { $ban_time = $bantime }     else { $ban_time = $fail2ban::params::bantime }
    if ($backend)  { $backend_name = $backend } else { $backend_name = $fail2ban::params::backend }
    if ($findtime) { $find_time = $findtime }   else { $find_time = $fail2ban::params::findtime }
    if ($maxretry) { $max_retry = $maxretry }   else { $max_retry = $fail2ban::params::maxretry }

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
        service { $fail2ban::params::service:
            ensure => running,
            enable => true,
            hasrestart => true,
            provider => systemd,
            require => Package[$fail2ban::params::package]
        }
    } else {
        service { $fail2ban::params::service:
            ensure => running,
            enable => true,
            hasrestart => true,
            require => Package[$fail2ban::params::package]
        }
    }
    if ('ssh' in $jails) {
        package { $fail2ban::params::whois: ensure => latest }
    }
}
