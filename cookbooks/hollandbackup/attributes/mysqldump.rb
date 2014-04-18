#
# Cookbook Name:: hollandbackup
# Attributes:: mysqldump
#
# Copyright 2012-2014, David Joos
#

default['hollandbackup']['mysqldump']['mysql_binpath'] = nil
default['hollandbackup']['mysqldump']['lock_method'] = nil
default['hollandbackup']['mysqldump']['exclude_invalid_views'] = nil
default['hollandbackup']['mysqldump']['dump_routines'] = nil
default['hollandbackup']['mysqldump']['dump_events'] = nil
default['hollandbackup']['mysqldump']['stop_slave'] = nil
default['hollandbackup']['mysqldump']['bin_log_position'] = nil
default['hollandbackup']['mysqldump']['flush_logs'] = nil
default['hollandbackup']['mysqldump']['file_per_database'] = nil
default['hollandbackup']['mysqldump']['additional_options'] = nil
default['hollandbackup']['mysqldump']['extra_defaults'] = nil
default['hollandbackup']['mysqldump']['estimate_method'] = nil

#database and table filtering
default['hollandbackup']['mysqldump']['filtering']['databases'] = nil
default['hollandbackup']['mysqldump']['filtering']['exclude_databases'] = nil
default['hollandbackup']['mysqldump']['filtering']['tables'] = nil
default['hollandbackup']['mysqldump']['filtering']['exclude_tables'] = nil

#[compression]
default['hollandbackup']['mysqldump']['compresssion']['method'] = nil
default['hollandbackup']['mysqldump']['compresssion']['inline'] = nil
default['hollandbackup']['mysqldump']['compresssion']['level'] = nil
default['hollandbackup']['mysqldump']['compresssion']['bin_path'] = nil

#[mysql:client]
default['hollandbackup']['mysqldump']['mysql_connection']['defaults_extra_file'] = nil
default['hollandbackup']['mysqldump']['mysql_connection']['user'] = nil
default['hollandbackup']['mysqldump']['mysql_connection']['password'] = nil
default['hollandbackup']['mysqldump']['mysql_connection']['socket'] = nil
default['hollandbackup']['mysqldump']['mysql_connection']['host'] = nil
default['hollandbackup']['mysqldump']['mysql_connection']['port'] = nil