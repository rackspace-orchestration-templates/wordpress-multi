Description
===========

This cookbook provides an easy way to install Holland Backup.

More information?
* http://hollandbackup.org

Requirements
============

## Cookbooks:

This cookbook depends on the following cookbooks:

* cron

This cookbook recommends on the following cookbooks:

* mysql

### Depending on your setup, these recommended cookbooks are actual dependencies (depends):
* Installing the mysqldump provider? You'll need the mysql cookbook to be available.

## Platforms:

* Debian
* Ubuntu
* CentOS
* RHEL

Attributes
==========

### repository.rb:

* `node['hollandbackup']['repository']['distro']` - The Linux distro to use, check the [openSUSE repositories](http://download.opensuse.org/repositories/home:/holland-backup/) for the proper name for your distro

### mysqldump.rb:
* See http://docs.hollandbackup.org/provider_configs/mysqldump.html

### general
* `node['hollandbackup']['mysqldump']['mysql_binpath']` - see Holland Backup mysqldump-docs, defaults to nil
* `node['hollandbackup']['mysqldump']['lock_method']` - see Holland Backup mysqldump-docs, defaults to nil
* `node['hollandbackup']['mysqldump']['exclude_invalid_views']` - see Holland Backup mysqldump-docs, defaults to nil
* `node['hollandbackup']['mysqldump']['dump_routines']` - see Holland Backup mysqldump-docs, defaults to nil
* `node['hollandbackup']['mysqldump']['dump_events']` - see Holland Backup mysqldump-docs, defaults to nil
* `node['hollandbackup']['mysqldump']['stop_slave']` - see Holland Backup mysqldump-docs, defaults to nil
* `node['hollandbackup']['mysqldump']['bin_log_position']` - see Holland Backup mysqldump-docs, defaults to nil
* `node['hollandbackup']['mysqldump']['flush_logs']` - see Holland Backup mysqldump-docs, defaults to nil
* `node['hollandbackup']['mysqldump']['file_per_database']` - see Holland Backup mysqldump-docs, defaults to nil
* `node['hollandbackup']['mysqldump']['additional_options']` - see Holland Backup mysqldump-docs, defaults to nil
* `node['hollandbackup']['mysqldump']['extra_defaults']` - see Holland Backup mysqldump-docs, defaults to nil
* `node['hollandbackup']['mysqldump']['estimate_method']` - see Holland Backup mysqldump-docs, defaults to nil

### database and table filtering
* `node['hollandbackup']['mysqldump']['filtering']['databases']` - see Holland Backup mysqldump-docs, defaults to nil
* `node['hollandbackup']['mysqldump']['filtering']['exclude_databases']` - see Holland Backup mysqldump-docs, defaults to nil
* `node['hollandbackup']['mysqldump']['filtering']['tables']` - see Holland Backup mysqldump-docs, defaults to nil
* `node['hollandbackup']['mysqldump']['filtering']['exclude_tables']` - see Holland Backup mysqldump-docs, defaults to nil

#### [compression]
* `node['hollandbackup']['mysqldump']['compresssion']['method']` - see Holland Backup mysqldump-docs, defaults to nil
* `node['hollandbackup']['mysqldump']['compresssion']['inline']` - see Holland Backup mysqldump-docs, defaults to nil
* `node['hollandbackup']['mysqldump']['compresssion']['level']` - see Holland Backup mysqldump-docs, defaults to nil
* `node['hollandbackup']['mysqldump']['compresssion']['bin_path']` - see Holland Backup mysqldump-docs, defaults to nil

#### [mysql:client]
* `node['hollandbackup']['mysqldump']['mysql_connection']['defaults_extra_file']` - see Holland Backup mysqldump-docs, defaults to nil
* `node['hollandbackup']['mysqldump']['mysql_connection']['user']` - see Holland Backup mysqldump-docs, defaults to nil
* `node['hollandbackup']['mysqldump']['mysql_connection']['password']` - see Holland Backup mysqldump-docs, defaults to nil
* `node['hollandbackup']['mysqldump']['mysql_connection']['socket']` - see Holland Backup mysqldump-docs, defaults to nil
* `node['hollandbackup']['mysqldump']['mysql_connection']['host']` - see Holland Backup mysqldump-docs, defaults to nil
* `node['hollandbackup']['mysqldump']['mysql_connection']['port']` - see Holland Backup mysqldump-docs, defaults to nil

### main.rb:
* See http://docs.hollandbackup.org/config.html#holland-conf-main-config

#### [holland]
* `node['hollandbackup']['main']['plugin_dirs']` - see Holland Backup main config-docs, defaults to nil
* `node['hollandbackup']['main']['backup_directory']` - see Holland Backup main config-docs, defaults to nil
* `node['hollandbackup']['main']['backupsets']` - see Holland Backup main config-docs, defaults to nil
* `node['hollandbackup']['main']['umask']` - see Holland Backup main config-docs, defaults to nil
* `node['hollandbackup']['main']['path']` - see Holland Backup main config-docs, defaults to nil

#### [logging]
* `node['hollandbackup']['main']['filename']` - see Holland Backup main config-docs, defaults to nil
* `node['hollandbackup']['main']['level']` - see Holland Backup main config-docs, defaults to nil

### backupsets.rb:

* `node['hollandbackup']['backupsets']` - A list of backupsets

### cron.rb:
The `hollandbackup::cron` recipe leverages the [cron lwrp](https://github.com/opscode-cookbooks/cron#resources-and-providers):
* `node['hollandbackup']['cron']['minute']` - Minute to run hollandbackup, defaults to `0`
* `node['hollandbackup']['cron']['hour']` - Hour to run hollandbackup, defaults to `3`
* `node['hollandbackup']['cron']['day']` - Day to run hollandbackup, defaults to `*`
* `node['hollandbackup']['cron']['month']` - Month to run hollandbackup, defaults to `*`
* `node['hollandbackup']['cron']['weekday']` - Weekday to run hollandbackup, defaults to `*`
* `node['hollandbackup']['cron']['user']` - User to run backup as, defaults to `root`
* `node['hollandbackup']['cron']['command']` - Command to run during backup, defaults to `holland -q backup`

Usage
=====

1. include `recipe[hollandbackup]` in a run list
2. include `recipe[hollandbackup::mysqldump]`
3. include `recipe[hollandbackup::main]`
4. include `recipe[hollandbackup::backupsets]`
5. tweak the attributes via attributes/default.rb
    --- OR ---
    override the attribute on a higher level (http://wiki.opscode.com/display/chef/Attributes#Attributes-AttributesPrecedence)

Optionally add `recipe[hollandbackup::cron]` to setup a cron job to run backups.

References
==========

* [Holland Backup home page] (http://hollandbackup.org)
* [Holland Backup installation] (http://wiki.hollandbackup.org/Installation)
* [Holland Backup configuration] (http://docs.hollandbackup.org/config.html)

License and Authors
===================

Author: David Joos <david@escapestudios.com>
Author: Escape Studios Development <dev@escapestudios.com>
Copyright: 2012, Escape Studios

Author: David Joos <development@davidjoos.com>
Copyright: 2012-2014, David Joos

Unless otherwise noted, all files are released under the MIT license,
possible exceptions will contain licensing information in them.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
