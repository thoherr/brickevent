######################################################################
# puppet provisioning module for rails applications
# apache and passenger stuff
# (c) 2013 42ways UG, teleteach GmbH

class railsapp::apache (
    $appname,
    $servername,
    $rubyversion,
    $passengerversion
)
{

    ######################################################################
    # apache with rvm / passager

    class {
      'rvm::passenger::apache':
        version => $passengerversion,
        ruby_version => $rubyversion,
        mininstances => '3',
        maxinstancesperapp => '0',
        maxpoolsize => '30',
        spawnmethod => 'smart-lv2';
    }


    ######################################################################
    # application directories and apache conf

    file { [ "/srv/www", "/srv/www/rails", "/srv/www/rails/${appname}", "/srv/www/rails/${appname}/releases", "/srv/www/rails/${appname}/shared" ] :
        ensure => "directory",
        owner  => "rails",
        group  => "rails",
        mode   => 755,
    }
    ->
    file { "/srv/www/rails/${appname}/shared/log" :  # TODO: this should done by capistrano, but it isn't....
        ensure => "link",
        target => "/var/log/${appname}"
    }

    file { "/var/log/${appname}" :
        ensure => "directory",
        owner  => "rails",
        group  => "rails",
        mode   => 755,
    }

    file { '/etc/apache2/sites-enabled':
        ensure => 'directory',
        recurse => true,
        purge => true,
        require => Class['rvm::passenger::apache']
    }
    ->
    file { "/etc/apache2/sites-enabled/001-${appname}" :
        ensure  => file,
        content => template("railsapp/vhost.erb")
    }

    service { 'apache2':
        ensure => running,
        subscribe => File["/etc/apache2/sites-enabled/001-${appname}"],
    }

}
