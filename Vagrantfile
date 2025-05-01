Vagrant.configure("2") do |config|
  config.vm.define "5ginabox" do |open5gs|
    open5gs.vm.box = "bento/ubuntu-20.04"
    open5gs.vm.hostname = "open5gs.local"
    open5gs.vm.network "private_network", ip: "192.168.56.101", hostname: true
    open5gs.vm.network "forwarded_port", guest: 3000, host: 8080
    open5gs.vm.network "forwarded_port", guest: 38412, host: 38412
    open5gs.vm.provider "vmware_desktop" do |vmw|
      vmw.gui = false
      vmw.memory = "2048"
      vmw.cpus = 2
    end
    open5gs.vm.provision "shell", path: "installation/open5gs.sh"
  end

  config.vm.define "ueransim" do |ueransim|
    ueransim.vm.box = "bento/ubuntu-20.04"
    ueransim.vm.hostname = "ueransim.local"
    ueransim.vm.network "private_network", ip: "192.168.56.102", hostname: true
    ueransim.vm.network "forwarded_port", guest: 38412, host: 38413
    ueransim.vm.provider "vmware_desktop" do |vmw|
      vmw.gui = false
      vmw.memory = "2048"
      vmw.cpus = 2
    end
    ueransim.vm.provision "shell", path: "installation/ueransim.sh"
  end
end
