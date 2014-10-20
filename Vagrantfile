# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu-server-12042-x64-vbox4210"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-12042-x64-vbox4210.box"

  config.vm.network :forwarded_port, guest: 3000, host: 3000

  config.librarian_puppet.placeholder_filename = ".gitkeep"

  config.vm.synced_folder "~/.ssh", "/home/vagrant/ssh"

  config.vm.provider :virtualbox do |vb|
    vb.name = "bored_gamer"
  end

  config.vm.provision :shell, :path => "bootstrap.sh"

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "init.pp"
    puppet.module_path    = ["modules"]
    puppet.options        = "--templatedir /vagrant/templates --fileserverconfig=/vagrant/fileserver.conf"
  end
end
