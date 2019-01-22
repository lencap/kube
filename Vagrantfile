# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "centos7-6-1810-virtualbox"

  vm1_name = "kmaster"
  vm1_ip   = "10.12.13.2"

  vm2_name = "kminion"
  vm2_ip   = "10.12.13.3"

  config.vm.define vm1_name do |vm1|
    vm1.vm.hostname = vm1_name
    vm1.vm.network "private_network", ip: vm1_ip
    vm1.vm.provision :shell, :inline => "echo " + vm1_ip + " " + vm1_name + " >> /etc/hosts"
    vm1.vm.provision :shell, :inline => "echo " + vm2_ip + " " + vm2_name + " >> /etc/hosts"
    vm1.vm.provider "virtualbox" do |vb|
      vb.name = vm1_name
      vb.customize ["modifyvm", :id, "--memory", 4096]
      vb.customize ["modifyvm", :id, "--cpus", 2]
      vb.customize ["modifyvm", :id, "--audio", "none"]
      vb.customize ["modifyvm", :id, "--usb", "off"]
      vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
    end
    vm1.vm.provision :shell, path: "bootstrap.sh"
  end

  config.vm.define vm2_name do |vm2|
    vm2.vm.hostname = vm2_name
    vm2.vm.network "private_network", ip: vm2_ip
    vm2.vm.provision :shell, :inline => "echo " + vm1_ip + " " + vm1_name + " >> /etc/hosts"
    vm2.vm.provision :shell, :inline => "echo " + vm2_ip + " " + vm2_name + " >> /etc/hosts"
    vm2.vm.provider "virtualbox" do |vb|
      vb.name = vm2_name
      vb.customize ["modifyvm", :id, "--memory", 4096]
      vb.customize ["modifyvm", :id, "--cpus", 2]
      vb.customize ["modifyvm", :id, "--audio", "none"]
      vb.customize ["modifyvm", :id, "--usb", "off"]
      vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
    end
    vm2.vm.provision :shell, path: "bootstrap.sh"
  end

end
