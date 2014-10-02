#
# Cookbook Name:: hollandbackup
# Recipe:: cron
#

cron_d 'holland-backup' do
  minute   node['hollandbackup']['cron']['minute']
  hour     node['hollandbackup']['cron']['hour']
  day      node['hollandbackup']['cron']['day']
  month    node['hollandbackup']['cron']['month']
  weekday  node['hollandbackup']['cron']['weekday']
  command  node['hollandbackup']['cron']['command']
  user     node['hollandbackup']['cron']['user']
end
