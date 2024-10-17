# -*- mode: ruby -*-
# vi: set ft=ruby : value


$script = <<-SHELL 
  apt-get update -y && apt-get upgrade -y
  apt-get install -y bind9 bind9utils bind9-doc
SHELL

Vagrant.configure("2") do |config|
  config.vm.box = "debian/bookworm64"
  config.vm.provision "shell", inline: $script
  config.vm.box_check_update = false
  config.ssh.insert_key = false
  config.vm.provider :virtualbox do |vb|
    vb.memory = 256
    vb.cpus = 1
  end

  config.vm.define :tierra do |master|
    master.vm.network "private_network", ip: "192.168.57.103"
    master.vm.hostname = "tierra"

    master.vm.provision "shell", inline: <<-SHELL 
      systemctl restart named
    SHELL
  end

  config.vm.define :venus do |slave|
    slave.vm.network "private_network", ip: "192.168.57.102"
    slave.vm.hostname = "venus"

    slave.vm.provision "shell", inline: <<-SHELL 
      systemctl restart named
    SHELL
  end
end
