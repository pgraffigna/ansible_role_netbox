ENV['VAGRANT_DEFAULT_PROVIDER'] = 'libvirt'
IMAGEN = "generic/ubuntu2004"

Vagrant.configure("2") do |config|
  config.ssh.insert_key = false
  config.vm.synced_folder ".", "/vagrant", type: "rsync", disabled: true

  config.vm.define :server do |s|
    s.vm.box = IMAGEN
    s.vm.hostname = "netbox.cultura.lab"
    s.vm.box_check_update = false

    s.vm.provision :docker
    s.vm.provision "shell", path: "netbox_install.sh"

    s.vm.provider :libvirt do |v|
      v.memory = 1024
      v.cpus = 2
    end
  end
end



