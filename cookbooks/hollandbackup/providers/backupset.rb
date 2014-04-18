#
# Cookbook Name:: hollandbackup
# Provider:: backupset
#
# Copyright 2012-2014, David Joos
#

def whyrun_supported?
    true
end

action :configure do
    Chef::Log.debug "BACKUPSET: #{new_resource.name}.conf"

    template "/etc/holland/backupsets/#{new_resource.name}.conf" do
        source "backupset.conf.erb"
        owner "root"
        group "root"
        mode 0644
        variables(
            :resource => new_resource
        )
    end
end