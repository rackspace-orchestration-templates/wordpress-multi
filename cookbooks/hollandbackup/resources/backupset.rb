#
# Cookbook Name:: hollandbackup
# Resource:: backupset
#
# Copyright 2012-2014, David Joos
#

actions :configure
default_action :configure

attribute :name, :kind_of => String, :name_attribute => true
attribute :plugin, :kind_of => String
attribute :backups_to_keep, :kind_of => Integer, :default => 1
attribute :estimated_size_factor, :kind_of => String, :default => "1.0"
attribute :auto_purge_failures, :kind_of => String, :default => "yes"
attribute :purge_policy, :kind_of => String, :default => "after-backup"
attribute :before_backup_command, :kind_of => String, :default => nil
attribute :after_backup_command, :kind_of => String, :default => nil
attribute :failed_backup_command, :kind_of => String, :default => nil

#backupset-specific plugin configuration
attribute :mysqldump, :kind_of => Hash, :default => {}

def initialize(*args)
    super
    @action = :configure
end