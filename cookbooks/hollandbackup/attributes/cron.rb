#
# Cookbook Name:: hollandbackup
# Attributes:: cron
#

default['hollandbackup']['cron']['minute'] = '0'
default['hollandbackup']['cron']['hour'] = '3'
default['hollandbackup']['cron']['day'] = '*'
default['hollandbackup']['cron']['month'] = '*'
default['hollandbackup']['cron']['weekday'] = '*'

default['hollandbackup']['cron']['user'] = 'root'
default['hollandbackup']['cron']['command'] = '/usr/sbin/holland -q backup'
