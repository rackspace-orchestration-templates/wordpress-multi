# coding: utf-8
#
# Cookbook Name:: rax-wordpress
# Recipe:: mysql
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

template '/root/.my.cnf' do
  source 'dotmy.cnf.erb'
  owner 'root'
  group 'root'
  mode '0600'
  variables ({
    rootpasswd: node['mysql']['server_root_password']
  })
end

innodb_mempercent = node[:rax][:mysql][:innodb_buffer_pool_mempercent].to_f

node.set[:rax_mysql_tunables][:config_options][:mysqld] = {
  'innodb-buffer-pool-size' => "#{(node['memory']['total'].to_i * innodb_mempercent ).floor * 1024}",
  'query_cache_size' => '32M',
  'skip-name-resolve' => ""
  }

include_recipe 'rax-mysql-tunables::default'

service 'mysql' do
  action :restart
end
