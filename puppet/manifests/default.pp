######################################################################
# puppet provisioning manifest for BrickEvent application
# (c) 2013 Thomas Herrmann

######################################################################
# preparation: run apt-get update to ensure up-to-date system

class { 'stdlib' :
    # declares standard stages, including "setup"
}

class apt_get_update {
  exec { '/usr/bin/apt-get -y update': }
}

class { 'apt_get_update':
  stage => setup
}


######################################################################
# iptables

class { 'firewall' :
}

resources { "firewall":
  purge => true
}

firewall { "000 accept all icmp requests":
  proto  => "icmp",
  action => "accept",
}

firewall { '002 accept related established rules':
  proto   => 'all',
  state   => ['RELATED', 'ESTABLISHED'],
  action  => 'accept',
}

firewall { '001 accept all to lo interface':
  proto   => 'all',
  iniface => 'lo',
  action  => 'accept',
}

firewall { '100 allow ssh':
  port   => [22],
  proto  => tcp,
  action => accept,
}

firewall { '999 drop all':
  proto   => 'all',
  action  => 'drop',
  before  => undef,
}


######################################################################
# MySQL database

class { 'mysql::server':
  config_hash => { 'root_password' => 'tQfeF2t6Ww' }
}

mysql::db { 'brick_event_production':
  user     => 'brick_event',
  password => 'brick_event',
  host     => 'localhost',
  grant    => ['all'],
}


######################################################################
# SSH keys

class { 'sshkeys' :
    destusers => [ 'rails', 'root' ]
}


######################################################################
# BrickEvent Application files

class { 'railsapp' :
    appname => "BrickEvent",
    servername => "bricking-bavaria.de",
    rubyversion => 'ruby-1.8.7-p352'
}

