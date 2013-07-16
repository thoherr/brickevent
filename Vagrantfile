# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "precise64"

  config.vm.network :public_network
  config.vm.network :forwarded_port, host: 8080, guest: 80
  config.vm.network :forwarded_port, host: 8443, guest: 443

  config.vm.provision :puppet do |puppet|
    # puppet.options = "--verbose --debug"
    puppet.options = "--verbose"
    puppet.module_path = [ "puppet/modules" ]
    puppet.manifests_path = "puppet/manifests"
    puppet.manifest_file = "default.pp"
  end

end
