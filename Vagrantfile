# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/jammy64"
  config.vm.hostname = "devbox"

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
  end

  # VirtualBox Guest Additions
  # vagrant plugin install vagrant-vbguest
  if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = false
  end

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 5432, host: 5433
  # config.vm.network "forwarded_port", guest: 3306, host: 3307

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  
  # Unix
  #config.vm.synced_folder "../Code", "/home/vagrant/Code", id: "v-root", mount_options: ["rw", "tcp", "nolock", "noacl", "async"], type: "nfs", nfs_udp: false
  
  # Windows
  config.vm.synced_folder "../Code", "/home/vagrant/Code"

  # Copy files
  # config.vm.provision "file", source: "./files/oracle-instantclient12.1-basic_12.1.0.2.0-2_amd64.deb", destination: "./oracle-instantclient12.1-basic_12.1.0.2.0-2_amd64.deb"
  # config.vm.provision "file", source: "./files/oracle-instantclient12.1-devel_12.1.0.2.0-2_amd64.deb", destination: "./oracle-instantclient12.1-devel_12.1.0.2.0-2_amd64.deb"
  config.vm.provision "file", source: "./templates/varnish", destination: "./varnish"
  config.vm.provision "file", source: "./templates/varnish.service", destination: "./varnish.service"
  config.vm.provision "file", source: "./templates/varnish.vcl", destination: "./varnish.vcl"
  config.vm.provision "file", source: "./templates/postgresql-custom.conf", destination: "./postgresql-custom.conf"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    # vb.gui = true
  
    # Customize the amount of memory on the VM:
    vb.memory = "2000"
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   sudo apt-get update
  #   sudo apt-get install -y apache2
  # SHELL
  
  config.vm.provision "shell", path: "provision.sh"
end