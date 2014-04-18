# coding: utf-8
#
# Cookbook Name:: rax-wordpress
# Recipe:: apache
#
# Copyright 2014
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

web_app 'wordpress' do
  template 'wordpress.conf.erb'
  docroot node['wordpress']['dir']
  server_name node['fqdn']
  server_aliases node['wordpress']['server_aliases']
  enable true
end

case node.platform
  when 'ubuntu', 'debian'
    execute 'set-apache-umask' do
      cwd '/etc/apache2'
      command 'echo "umask 5002" >> /etc/apache2/envvars'
      not_if 'grep -q umask /etc/apache2/envvars'
      notifies :restart, "service[apache2]", :delayed
    end
end

# SSL Configuration
if node['apache']['ssl_private_key'] && node['apache']['ssl_cert']
  node.set['rax']['wordpress']['use_ssl'] = true

  include_recipe 'apache2::mod_proxy'
  include_recipe 'apache2::mod_proxy_http'

  # Certs are installed in the x509 recipe

  web_app 'wordpress-ssl' do
    template 'wordpress-ssl.conf.erb'
    docroot node['wordpress']['dir']
    server_name node['fqdn']
    server_aliases node['wordpress']['server_aliases']
    enable true
  end

else
  Chef::Log.debug('SSL Key and Cert not found, no SSL config will take place.')
end
