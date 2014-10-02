#
# Cookbook Name:: hollandbackup
# Recipe:: backupset-config
#
# Copyright 2012-2014, David Joos
#

backupsets = node['hollandbackup']['backupsets']

unless backupsets.nil?
    backupsets.keys.each do |key|
        hollandbackup_backupset "#{key}" do
            plugin                backupsets[key]['plugin']
            backups_to_keep       backupsets[key]['backups_to_keep']
            estimated_size_factor backupsets[key]['estimated_size_factor']
            auto_purge_failures   backupsets[key]['auto_purge_failures']
            purge_policy          backupsets[key]['purge_policy']
            before_backup_command backupsets[key]['before_backup_command']
            after_backup_command  backupsets[key]['after_backup_command']
            failed_backup_command backupsets[key]['failed_backup_command']
            mysqldump             backupsets[key]['mysqldump']
        end
    end
end