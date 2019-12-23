# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "centos7"
  config.vm.box_url = "file://centos7.box"

  vm1_name = "k101"
  vm1_ip   = "10.10.10.1"

  vm2_name = "k102"
  vm2_ip   = "10.10.10.2"

  config.vm.define vm1_name do |vm1|
    vm1.vm.hostname = vm1_name
    vm1.vm.network "private_network", ip: vm1_ip
    vm1.vm.provision :shell, :inline => "echo " + vm1_ip + " " + vm1_name + " >> /etc/hosts"
    vm1.vm.provision :shell, :inline => "echo " + vm2_ip + " " + vm2_name + " >> /etc/hosts"
    vm1.vm.provider "virtualbox" do |vb|
      vb.name = vm1_name
      vb.customize ["modifyvm", :id, "--memory", 16384]
      vb.customize ["modifyvm", :id, "--cpus", 4]
      vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
      vb.customize ["modifyvm", :id, "--audio", "none"]
      vb.customize ["modifyvm", :id, "--usb", "off"]
      vb.customize ["modifyvm", :id, "--vrde", "off"]
      vb.customize ["modifyvm", :id, "--vram", "12"]
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
      vb.customize ["modifyvm", :id, "--memory", 16384]
      vb.customize ["modifyvm", :id, "--cpus", 4]
      vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
      vb.customize ["modifyvm", :id, "--audio", "none"]
      vb.customize ["modifyvm", :id, "--usb", "off"]
      vb.customize ["modifyvm", :id, "--vrde", "off"]
      vb.customize ["modifyvm", :id, "--vram", "12"]
      vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
    end
    vm2.vm.provision :shell, path: "bootstrap.sh"
  end

end
