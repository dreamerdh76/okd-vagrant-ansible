Vagrant.configure("2") do |config|
    config.vm.box = "centos/7"
  
    nodes = {
      "master"  => "192.168.50.10",
      "worker1" => "192.168.50.11"
    }
  
    nodes.each do |name, ip|
      config.vm.define name do |node|
        node.vm.hostname = "#{name}.okd.local"
        node.vm.network  "private_network", ip: ip
        node.vm.provider :virtualbox do |vb|
          vb.cpus   = 2
          vb.memory = 3072
        end
      end
    end
  end
  