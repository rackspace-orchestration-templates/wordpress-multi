# coding: utf-8
#
# Cookbook Name:: rax-wordpress
# Recipe:: varnish
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

template 'Setup WordPress Varnish Configuration' do
  path File.join(node['varnish']['dir'], node['varnish']['vcl_conf'])
  source 'wordpress.vcl.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables ({
    master: node['rax']['varnish']['master_backend'],
    domain: node['rax']['apache']['domain'],
    purge_hosts: node['rax']['varnish']['purge_acl']
  })
  notifies :restart, 'service[varnish]', :delayed
end
