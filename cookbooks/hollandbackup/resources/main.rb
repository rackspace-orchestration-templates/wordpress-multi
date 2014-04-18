#
# Cookbook Name:: hollandbackup
# Resource:: main
#
# Copyright 2012-2014, David Joos
#

actions :configure
default_action :configure

#[holland]
attribute :plugin_dirs, :kind_of => String, :default => "/usr/share/holland/plugins"
attribute :backup_directory, :kind_of => String, :default => "/var/spool/holland"
attribute :backupsets, :kind_of => String, :default => "default"
attribute :umask, :kind_of => String, :default => "0007"
attribute :path, :kind_of => String, :default => "/usr/local/bin:/usr/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin"

#[logging]
attribute :filename, :kind_of => String, :default => "/var/log/holland/holland.log"
attribute :level, :kind_of => String, :default => "info"

def initialize(*args)
    super
    @action = :configure
end