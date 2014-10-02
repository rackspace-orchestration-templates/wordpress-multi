#
# Cookbook Name:: hollandbackup
# Provider:: mysqldump
#
# Copyright 2012-2014, David Joos
#

def whyrun_supported?
    true
end

action :configure do
    Chef::Log.debug "PROVIDER: mysqldump.conf"

    template "/etc/holland/providers/mysqldump.conf" do
        source "mysqldump.conf.erb"
        owner "root"
        group "root"
        mode 0644
        variables(
            :resource => new_resource
        )
    end
end