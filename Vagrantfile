# -*- mode: ruby -*-
# vi: set ft=ruby :

#
# Copyright 2019 Northstrat, Inc.
#

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

    # The most common configuration options are documented and commented below.
    # For a complete reference, please see the online documentation at
    # https://docs.vagrantup.com.

    config.ssh.forward_x11 = true

    # Disable automatic box update checking. If you disable this, then
    # boxes will only be checked for updates when the user runs
    # `vagrant box outdated`. This is not recommended.
    # config.vm.box_check_update = false

    # Share an additional folder to the guest VM. The first argument is
    # the path on the host to the actual folder. The second argument is
    # the path on the guest to mount the folder. And the optional third
    # argument is a set of non-required options.
    config.vm.synced_folder "../app-web", "/app-web"
    config.vm.synced_folder "../app-mobile", "/app-mobile"
    config.vm.synced_folder "../app-services", "/app-services"
    config.vm.synced_folder "../mobileapp-awsdev", "/mobileapp-awsdev"

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
    #   apt-get update
    #   apt-get install -y apache2
    # SHELL
    config.vm.provision :shell, path: "scripts/bootstrap.sh"
    config.vm.provision :shell, path: "scripts/install_git.sh"
    #config.vm.provision :shell, path: "scripts/install_java.sh"
    #config.vm.provision :shell, path: "scripts/install_gradle.sh", args: ['3.5']
    #config.vm.provision :shell, path: "scripts/install_aws.sh"
    config.vm.provision :shell, path: "scripts/install_node.sh"

    Dir.glob('servers/*.json') do |file|
        json = (JSON.parse(File.read(file)))['server']
        id = json['id']
        hostname = json['hostname']
        network = json['network']
        #memory = json['memory']
        cpuExecutionCap = json['cpuExecutionCap']
        cpus = json['cpus']
        desktop = json.has_key?("desktop") ? json["desktop"] : nil
        gui = !desktop.nil? && desktop.has_key?("display") ? desktop['display'] : false
        desktop_type = !desktop.nil? && desktop.has_key?("type") ? desktop['type'] : "gnome"
        aws = json.has_key?("aws") ? json["aws"] : nil

        # This little snippet will determine host memory size based on OS
        host = RbConfig::CONFIG['host_os']
        if host =~ /darwin/
            # sysctl returns Bytes and we need to convert to MB
            mem = `sysctl -n hw.memsize`.to_i / 1024
        elsif host =~ /linux/
            # meminfo shows KB and we need to convert to MB
            mem = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i 
        elsif host =~ /mswin|mingw|cygwin/
            # Windows code via https://github.com/rdsubhas/vagrant-faster
            mem = `wmic computersystem Get TotalPhysicalMemory`.split[1].to_i / 1024
        end
        # We only want to use 1/4 the host memory size
        mem = mem / 1024 / 4

        config.vm.define id do |server|
            
            server.vm.box = json.has_key?('box') ? json['box'] : "ubuntu/xenial64"
            server.vm.hostname = hostname
            server.vm.define id

            server.vm.provider "virtualbox" do |vb|
                vb.gui = gui
                vb.name = id
                #vb.memory = memory
                vb.customize ["modifyvm", :id, "--memory", mem]
                vb.cpus = cpus
                vb.customize ["modifyvm", id, "--cpuexecutioncap", cpuExecutionCap]
            end

            # contains a list of possible bridge adapters and the first one to successfully
            # bridged will be used
            bridge = network.has_key?("bridge") ? true : false
            if bridge then
                server.vm.network network['type'], ip: network['ip'], bridge: network['bridge']
            else
                server.vm.network network['type'], ip: network['ip']
            end

            network['ports'].each do |p|
                server.vm.network "forwarded_port", guest: p['guest'], host: p['host']
            end
            

            if !desktop.nil? then
                server.vm.provision :shell, path: "scripts/install_desktop.sh", args: [ "#{desktop_type}" ]
                server.vm.provision :shell, path: "scripts/install_android.sh"
            end

            if !aws.nil? then
                accessKey = aws.has_key?('accessKey') ? aws['accessKey'] : ""
                accessSecret = aws.has_key?('accessSecret') ? aws['accessSecret'] : ""
                awsRegion = aws.has_key?('region') ? aws['region'] : ""
                server.vm.provision :shell, path: "scripts/install_aws.sh", env: { "AWS_ACCESS_KEY_ID" => "#{accessKey}", "AWS_SECRET_ACCESS_KEY" => "#{accessSecret}", "AWS_DEFAULT_REGION" => "#{awsRegion}"}
            end
        end
    end

end
