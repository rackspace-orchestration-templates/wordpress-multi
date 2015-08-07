# coding: utf-8
#
# Cookbook Name:: rax-wordpress
# Recipe:: user
#
# Copyright 2014
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

group node['rax']['wordpress']['user']['group']

chef_gem 'unix-crypt'

user node['rax']['wordpress']['user']['name'] do
  action :create
  comment 'WordPress user'
  home node['wordpress']['dir']
  gid node['rax']['wordpress']['user']['group']
  shell '/bin/bash'
  if node['rax']['wordpress']['user']['password_hash']
    password node['rax']['wordpress']['user']['password_hash']
  elsif node['rax']['wordpress']['admin_pass']
    require 'unix_crypt'
    password UnixCrypt::SHA512.build(node['rax']['wordpress']['admin_pass'])
  end
end

group node['apache']['group'] do
  append true
  members node['rax']['wordpress']['user']['name']
  action :modify
end

execute 'Setup the various WordPress file system permissions' do
  command <<-EOH
  # Give permissions to the entire directory WordPress install to the WP user
  chown -R \
  #{node['rax']['wordpress']['user']['name']}:#{node['rax']['wordpress']['user']['group']} \
  #{node['wordpress']['dir']}

  # Give permissions to the top-level directory WordPress install to the apache user
  chown \
  #{node['apache']['user']}:#{node['apache']['group']} \
  #{node['wordpress']['dir']}

  # Make WordPress config file writable for the web server
  chown \
  #{node['rax']['wordpress']['user']['name']}:#{node['rax']['wordpress']['user']['group']} \
  #{File.join(node['wordpress']['dir'], 'wp-config.php')}

  chmod 664 #{File.join(node['wordpress']['dir'], 'wp-config.php')}

  # Set wp-content permissions
  chown -R \
  #{node['rax']['wordpress']['user']['name']}:#{node['apache']['group']} \
  #{File.join(node['wordpress']['dir'], 'wp-content')}

  find #{File.join(node['wordpress']['dir'], 'wp-content')} -type d -print | \
  xargs chmod 775

  find #{File.join(node['wordpress']['dir'], 'wp-content')} -type f -print | \
  xargs chmod 664

  chmod 2775 #{File.join(node['wordpress']['dir'], 'wp-content')}
  EOH
  action :run
end
