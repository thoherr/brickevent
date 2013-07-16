######################################################################
# puppet provisioning module for a basic rails application server
# (c) 2013 42ways UG, teleteach GmbH

class railsapp (
    $appname            = 'undefined',
    $servername         = 'myserver.example.com',
    $rubyversion        = 'ruby-1.9.3-p448',
    $passengerversion   = '3.0.19'
 )
{
    
    firewall { '110 allow http and https access':
        port   => [80, 443],
        proto  => tcp,
        action => accept
    }

    ######################################################################
    # rvm and ruby

    class { 'railsapp::ruby' :
        rubyversion => $rubyversion,
        passengerversion => $passengerversion
    }

    ######################################################################
    # application directory and apache conf

    class { 'railsapp::apache' :
        appname => $appname,
        servername => $servername,
        rubyversion => $rubyversion,
        passengerversion => $passengerversion
    }

    notify { "Railsapp for Application ${appname} on ${servername} with ${rubyversion} and Passenger ${passengerversion}" : }
}
