Vagrant.configure("2") do |config|
    config.vm.define "lab1" do |subconfig|
        subconfig.vm.box = "ubuntu/focal64"
        subconfig.vm.hostname="lab1"
        subconfig.vm.network "private_network", 
            ip: "192.168.1.10",
            netmask: "255.255.255.0",
            virtualbox__intnet: true,
            virtualbox__intnet:"intneta"
        subconfig.vm.network "private_network",
            ip: "192.168.2.10",
            virtualbox__intnet: true,
            virtualbox__intnet:"intnetb"
        subconfig.vm.provider :virtualbox do |vb|
            vb.customize ["modifyvm", :id, "--memory", "4096"]
            vb.customize ["modifyvm", :id, "--cpus", "2"]
        end
        #subconfig.vm.provision "file", source: "test.txt", destination: "~/test.txt"
        subconfig.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/me.pub"
        #config.vm.synced_folder "sync_folder", "/sync_folder"
        subconfig.vm.provision "shell", inline: <<-SHELL
            cat /home/vagrant/.ssh/me.pub >> /home/vagrant/.ssh/authorized_keys
            echo 1 > /proc/sys/net/ipv4/ip_forward
            sudo echo "192.168.1.11 lab2" | sudo tee -a /etc/hosts
            sudo echo "192.168.2.11 lab3" | sudo tee -a /etc/hosts
            sudo apt install net-tool
        SHELL
    end

    config.vm.define "lab2" do |subconfig|
        subconfig.vm.box = "ubuntu/focal64"
        subconfig.vm.hostname="lab2"
        subconfig.vm.network "private_network", 
            ip: "192.168.1.11",
            netmask: "255.255.255.0",
            virtualbox__intnet: true,
            virtualbox__intnet:"intneta"
        subconfig.vm.provider :virtualbox do |vb|
            vb.customize ["modifyvm", :id, "--memory", "4096"]
            vb.customize ["modifyvm", :id, "--cpus", "2"]
        end
        subconfig.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/me.pub"
        subconfig.vm.provision "shell", inline: <<-SHELL
            cat /home/vagrant/.ssh/me.pub >> /home/vagrant/.ssh/authorized_keys
            sudo echo "192.168.1.10 lab1" | sudo tee -a /etc/hosts
            ip route add 192.168.2.11 via 192.168.1.10 dev enp0s8
            sudo apt install net-tools
        SHELL
    end


    config.vm.define "lab3" do |subconfig|
        subconfig.vm.box = "ubuntu/focal64"
        subconfig.vm.hostname="lab3"
        subconfig.vm.network "private_network", 
            ip: "192.168.2.11",
            netmask: "255.255.255.0",
            virtualbox__intnet: true,
            virtualbox__intnet:"intnetb"
        subconfig.vm.provider :virtualbox do |vb|
            vb.customize ["modifyvm", :id, "--memory", "4096"]
            vb.customize ["modifyvm", :id, "--cpus", "2"]
        end
        subconfig.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/me.pub"
        subconfig.vm.provision "shell", inline: <<-SHELL
            cat /home/vagrant/.ssh/me.pub >> /home/vagrant/.ssh/authorized_keys
            sudo echo "192.168.2.10 lab1" | sudo tee -a /etc/hosts
            ip route add 192.168.1.11 via 192.168.2.10 dev enp0s8
            sudo apt install net-tools
        SHELL
    end
end