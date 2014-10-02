#
# Cookbook Name:: hollandbackup
# Provider:: main
#
# Copyright 2012-2014, David Joos
#

def whyrun_supported?
    true
end

action :configure do
    Chef::Log.debug "MAIN: holland.conf"

    template "/etc/holland/holland.conf" do
        source "holland.conf.erb"
        owner "root"
        group "root"
        mode 0644
        variables(
            :resource => new_resource
        )
    end
end