# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.hostname = 'rax-mysql-tunables'
  config.vm.box = 'ubuntu-12.04'
  config.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_#{config.vm.box}_chef-provisionerless.box"
  config.omnibus.chef_version = 'latest'
#  config.berkshelf.enabled = true

  config.vm.provision :shell, :inline => "sudo apt-get update; sudo apt-get -y install build-essential"

  config.vm.provision :chef_solo do |chef|
    chef.json = {
      :rax_mysql_tunables => {
        :config_options => {
          :mysqld => {
            "innodb-buffer-pool-size" => 128000000
          }
        }
      }
    }
    chef.cookbooks_path = ["cookbooks"]
    chef.run_list = [
        'recipe[mysql::server]',
        'recipe[rax-mysql-tunables::default]'
    ]
  end
end
