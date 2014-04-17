# coding: utf-8
#
# Cookbook Name:: rax-wordpress
# Recipe:: lsyncd
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

include_recipe 'lsyncd'
include_recipe 'rax-wordpress::user'

if node['rax']['lsyncd']['ssh']['private_key']
  directory File.join(node['wordpress']['dir'], '.ssh') do
    owner node['rax']['wordpress']['user']['name']
    group node['rax']['wordpress']['user']['group']
    mode '0700'
    action :create
  end

  file File.join(node['wordpress']['dir'], '.ssh/id_rsa') do
    content node['rax']['lsyncd']['ssh']['private_key']
    owner node['rax']['wordpress']['user']['name']
    group node['rax']['wordpress']['user']['group']
    mode '0600'
    action :create
  end

  node['rax']['lsyncd']['exclusions'].each do |excl|
    execute "Adding #{excl} to lsyncd exclusions list" do
      command "echo '#{excl}' >> #{node['rax']['lsyncd']['excludes_file']}"
      not_if "grep '^#{excl}$' #{node['rax']['lsyncd']['excludes_file']}"
    end
  end
end

node['rax']['lsyncd']['clients'].each do |client|
  lsyncd_target client.gsub(/\./, '-') do
    source node['wordpress']['dir']
    target node['wordpress']['dir']
    user node['rax']['wordpress']['user']['name']
    host client
    rsync_opts node['rax']['lsyncd']['rsync_opts']
    exclude_from node['rax']['lsyncd']['excludes_file']
    notifies :restart, 'service[lsyncd]', :delayed
  end
end

service 'lsyncd' do
  action :start
end
