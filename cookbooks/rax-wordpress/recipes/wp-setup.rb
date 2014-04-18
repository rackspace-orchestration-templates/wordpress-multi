# coding: utf-8
#
# Cookbook Name:: rax-wordpress
# Recipe:: wp-setup
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

template File.join(Chef::Config[:file_cache_path], 'wordpress-cli-installer.sh') do
  source 'wordpress-cli-installer.sh'
  owner 'root'
  group 'root'
  mode 00700
  not_if { File.exists?(::File.join(Chef::Config[:file_cache_path], 'wordpress-cli-installer.sh')) }
end

execute "configure_wordpress_#{node['rax']['apache']['domain']}" do
  cwd Chef::Config[:file_cache_path]
  command <<-EOH
  sh wordpress-cli-installer.sh \
  -b 'http://#{node['rax']['apache']['domain']}#{node['rax']['wordpress']['path']}' \
  -T '#{node['rax']['wordpress']['site_title']}' \
  -e '#{node['rax']['wordpress']['admin_email']}' \
  -u '#{node['rax']['wordpress']['admin_user']}' \
  -p '#{node['rax']['wordpress']['admin_pass']}' #{node['wordpress']['dir']}
  EOH
  not_if "mysql -h #{node['wordpress']['db']['host']} \
  -u #{node['wordpress']['db']['user']} \
  -e \"select * from #{node['wordpress']['db']['name']}.#{node['wordpress']['db']['prefix']}options where option_name = 'siteurl';\" \
  -p#{node['wordpress']['db']['pass']}"
end
