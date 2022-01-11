Vagrant.configure("2") do |config|
  config.ssh.insert_key = false
  config.vm.synced_folder ".", "/vagrant", disabled: true 
 
  config.vm.define :nodo1 do |nodo1|
    nodo1.vm.box = "generic/ubuntu2004"
    nodo1.vm.hostname = "nodo1"
    nodo1.vm.box_check_update = false
    nodo1.vm.network "private_network", ip: "192.168.60.10"
    
    nodo1.vm.provision :docker
    nodo1.vm.provision :docker_compose

    nodo1.vm.provision "shell", path: "install.sh"

    nodo1.vm.provider :libvirt do |v|
      v.memory = 1024  
    end  
  end
end


