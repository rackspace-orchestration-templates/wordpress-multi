# coding: utf-8
#
# Cookbook Name:: rax-wordpress
# Recipe:: x509
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

node.set['vsftpd']['ssl_private_key_path'] = node['rax']['x509']['key_file']
node.set['vsftpd']['ssl_cert_path'] = node['rax']['x509']['cert_file']

if node['rax']['apache']['ssl']['cert'] && node['rax']['apache']['ssl']['key']
  file File.join(node['rax']['apache']['ssl']['certpath'], "#{node['rax']['apache']['domain']}.crt") do
    content node['rax']['apache']['ssl']['cert']
    owner 'root'
    group 'root'
    mode '0644'
    action :create
  end

  file File.join(node['rax']['apache']['ssl']['keypath'], "#{node['rax']['apache']['domain']}.key") do
    content node['rax']['apache']['ssl']['key']
    owner 'root'
    group 'root'
    mode '0600'
    action :create
  end

  file File.join(node['rax']['apache']['ssl']['certpath'], "#{node['rax']['apache']['domain']}.ca.crt") do
    content node['rax']['apache']['ssl']['cacert']
    owner 'root'
    group 'root'
    mode '0644'
    action :create
    only_if node['rax']['apache']['ssl']['cacert']
  end

else # Generate self signed cert
  package 'openssl'

  execute 'Setup self signed cert' do
    command <<-EOH
    openssl req \
      -x509 -nodes -days #{node['rax']['x509']['days']} \
      -subj '/CN=#{node['rax']['x509']['cn'] }/O=#{node['rax']['x509']['o']}/C=#{node['rax']['x509']['c']}/ST=#{node['rax']['x509']['st']}/L=#{node['rax']['x509']['l']}' \
      -newkey rsa:#{node['rax']['x509']['rsa']} \
      -keyout #{node['rax']['x509']['key_file']} \
      -out #{node['rax']['x509']['cert_file']}
    chmod 600 #{node['rax']['x509']['key_file']}
    EOH
    not_if { ::File.exists?(node['rax']['x509']['key_file'] ) or ::File.exists?(node['rax']['x509']['cert_file']) }
  end
end
