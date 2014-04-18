#
# Cookbook Name:: hollandbackup
# Recipe:: main-config
#
# Copyright 2012-2014, David Joos
#

hollandbackup_main "hollandbackup-main-config" do
    #[holland]
    plugin_dirs      node['hollandbackup']['main']['plugin_dirs']
    backup_directory node['hollandbackup']['main']['backup_directory']
    backupsets       node['hollandbackup']['main']['backupsets']
    umask            node['hollandbackup']['main']['umask']
    path             node['hollandbackup']['main']['path']
    #[logging]
    filename         node['hollandbackup']['main']['filename']
    level            node['hollandbackup']['main']['level']
    action :configure
end