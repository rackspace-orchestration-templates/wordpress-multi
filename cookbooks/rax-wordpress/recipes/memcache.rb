# coding: utf-8
#
# Cookbook Name:: rax-wordpress
# Recipe:: memcache
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

include_recipe 'php::module_memcache'

# Change PHP to use memcached for storing sessions

php_conf_dir = node[:rax][:memcache][:php_conf_dir]

bash 'Change session_save.handler' do
  cwd php_conf_dir
  code <<-EOH
  sed -i 's/session.save_handler =.*/session.save_handler = memcache/g' php.ini
  EOH
  not_if "grep '^session.save_handler = memcache$' #{File.join(php_conf_dir,
                                                               'php.ini')}"
  notifies :restart, 'service[apache2]', :delayed
end

save_path = "session.save_path = \"tcp:\\/\\/#{node[:rax][:memcache][:server]}:"\
            "#{node[:rax][:memcache][:port]}?"\
            "persistent=#{node[:rax][:memcache][:persistent]}"\
            "\\&weight=#{node[:rax][:memcache][:weight]}"\
            "\\&timeout=#{node[:rax][:memcache][:timeout]}"\
            "\\&retry_interval=#{node[:rax][:memcache][:retry_interval]}\""

bash 'Change session.save_path to use memcache' do
  cwd php_conf_dir
  code <<-EOH
  sed -i 's/^\;session.save_path =.*/#{save_path}/g' #{File.join(php_conf_dir,
                                                                 'php.ini')}
  EOH
  not_if "grep '^#{save_path}$' #{File.join(php_conf_dir, 'php.ini')}"
  notifies :restart, 'service[apache2]', :delayed
end

bash 'Update session.save_path if it has changed' do
  cwd php_conf_dir
  code <<-EOH
  sed -i 's/^session.save_path =.*/#{save_path}/g' #{File.join(php_conf_dir,
                                                               'php.ini')}
  EOH
  not_if "grep '^#{save_path}$' #{File.join(php_conf_dir, 'php.ini')}"
  notifies :restart, 'service[apache2]', :delayed
end
