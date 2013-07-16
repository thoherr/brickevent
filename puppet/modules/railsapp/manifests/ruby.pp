######################################################################
# puppet provisioning module for rails applications
# rvm and ruby stuff
# (c) 2013 42ways UG, teleteach GmbH

class railsapp::ruby (
    $rubyversion,
    $passengerversion
)
{
    
    ######################################################################
    # rails user

    group { 'rails' :
      ensure => present,
    }

    user { 'rails' :
      ensure     => present,
      gid        => 'rails',
      shell      => '/bin/bash',
      home       => '/home/rails',
      managehome => true,
    }


    ######################################################################
    # RVM, Ruby, Gemsets and Passenger (with Apache)

    class { 'rvm':
        require => Stage['setup']
    }

    rvm::system_user { rails: ; }

    rvm_system_ruby { $rubyversion :
        ensure => 'present',
        default_use => false;
    }

    rvm_gem { "$rubyversion/bundler" :
        ensure => latest,
        require => Rvm_system_ruby[$rubyversion];
    }

}
