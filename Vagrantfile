# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.box = "precise32"

    config.vm.box_url = "http://files.vagrantup.com/precise32.box"

    config.vm.network :forwarded_port, guest: 80, host: 8080
    config.vm.network :forwarded_port, guest: 80, host: 80
    config.vm.network :forwarded_port, guest: 3306, host: 3306

    config.vm.provision :shell, :path => "vagrant/install.sh"

    config.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777", "fmode=766"]

    # If true, then any SSH connections made will enable agent forwarding.
    # Default value: false
    config.ssh.forward_agent = true
end
