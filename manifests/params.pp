class fail2ban::params {

### Application related parameters

  $package = $::operatingsystem ? {
    default => 'fail2ban',
  }

  $package_systemd = $::operatingsystem ? {
    default => 'fail2ban-systemd',
  }

  $package_firewalld = $::operatingsystem ? {
    default => 'fail2ban-firewalld',
  }

  $service = $::operatingsystem ? {
    default => 'fail2ban',
  }

  $config_dir = $::operatingsystem ? {
    default => '/etc/fail2ban',
  }

  $config_file = $::operatingsystem ? {
    default => "${config_dir}/fail2ban.local",
  }

  $jail_file = $::operatingsystem ? {
    default => "${config_dir}/jail.local",
  }

  $log_dir = $::operatingsystem ? {
    default => '/var/log/fail2ban',
  }

  $log_file = $::operatingsystem ? {
    default => "SYSLOG",
  }

  $pid_file = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => '/var/run/fail2ban/fail2ban.pid',
    default => '/var/run/fail2ban/fail2ban.pid',
  }

  $log_level = 'WARNING'
  $socket = '/var/run/fail2ban/fail2ban.sock'

  $ignoreip = ['127.0.0.1/8']
  $bantime = '600'
  $findtime = '600'
  $maxretry = '5'
  $backend = 'auto'
  $action = 'iptables'
  $mailto = "hostmaster@${::domain}"
  $banaction = 'iptables-multiport'
  $mta = 'sendmail'
  $jails_protocol = 'tcp'
  $jails_chain = 'INPUT'
  case $operatingsystem {
    RedHat,Scientific,CentOS: {
      if ($operatingsystemmajrelease * 1 < 7) {
        $whois = 'jwhois'
      } else {
        $whois = 'whois'
      }
    }
    default: {
      $whois = 'whois'
    }
  }
  $jail_defaults = {
                    'imap'   => { 'filter' => 'dovecot', 'port' => 'imap', 'logpath' => '/var/log/maillog' },
                    'pop3'   => { 'filter' => 'mail', 'port' => 'pop3', 'logpath' => '/var/log/maillog' },
                    'sshd'   => { 'filter' => 'sshd', 'port' => 'sshd', 'logpath' => $::osfamily ? { /?i:Debian|Ubuntu|Mint)/ => '/var/log/auth.log', default => '/var/log/secure' } },
                    'vsftpd' => { 'filter' => 'vsftpd', 'port' => 'ftp', 'logpath' => '/var/log/vsftpd.log' },
                   }
}
