#
# Cookbook Name:: hollandbackup
# Recipe:: mysqldump
#
# Copyright 2012-2014, David Joos
#

include_recipe "mysql::client"

package "holland-mysqldump" do
    action :upgrade
    case node['platform_family']
    when 'debian'
        options "--force-yes"
    end
end

hollandbackup_mysqldump "holland-configure-mysqldump-provider" do
    #[mysqldump]
    mysql_binpath         node['hollandbackup']['mysqldump']['mysql_binpath']
    lock_method           node['hollandbackup']['mysqldump']['lock_method']
    exclude_invalid_views node['hollandbackup']['mysqldump']['exclude_invalid_views']
    dump_routines         node['hollandbackup']['mysqldump']['dump_routines']
    dump_events           node['hollandbackup']['mysqldump']['dump_events']
    stop_slave            node['hollandbackup']['mysqldump']['stop_slave']
    bin_log_position      node['hollandbackup']['mysqldump']['bin_log_position']
    flush_logs            node['hollandbackup']['mysqldump']['flush_logs']
    file_per_database     node['hollandbackup']['mysqldump']['file_per_database']
    additional_options    node['hollandbackup']['mysqldump']['additional_options']
    extra_defaults        node['hollandbackup']['mysqldump']['extra_defaults']
    estimate_method       node['hollandbackup']['mysqldump']['estimate_method']
    #database and table filtering
    databases             node['hollandbackup']['mysqldump']['filtering']['databases']
    exclude_databases     node['hollandbackup']['mysqldump']['filtering']['exclude_databases']
    tables                node['hollandbackup']['mysqldump']['filtering']['tables']
    exclude_tables        node['hollandbackup']['mysqldump']['filtering']['exclude_tables']
    #[compression]
    method                node['hollandbackup']['mysqldump']['compresssion']['method']
    inline                node['hollandbackup']['mysqldump']['compresssion']['inline']
    level                 node['hollandbackup']['mysqldump']['compresssion']['level']
    bin_path              node['hollandbackup']['mysqldump']['compresssion']['bin_path']
    #[mysql:client]
    defaults_extra_file   node['hollandbackup']['mysqldump']['mysql_connection']['defaults_extra_file']
    user                  node['hollandbackup']['mysqldump']['mysql_connection']['user']
    password              node['hollandbackup']['mysqldump']['mysql_connection']['password']
    socket                node['hollandbackup']['mysqldump']['mysql_connection']['socket']
    host                  node['hollandbackup']['mysqldump']['mysql_connection']['host']
    port                  node['hollandbackup']['mysqldump']['mysql_connection']['port']
end
