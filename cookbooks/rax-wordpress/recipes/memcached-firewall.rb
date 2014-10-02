# coding: utf-8
#
# Cookbook Name:: rax-wordpress
# Recipe:: memcached-firewall
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

clients = node[:rax][:memcached][:clients].flatten
listen_port = node['memcached']['port']

case node['platform_family']
when 'debian'
  firewall 'ufw' do
    action :enable
  end

  firewall_rule 'Deny all connections to memcached by default' do
    port      listen_port
    direction :in
    interface node['rax']['memcached']['interface']
    action    :deny
  end

  clients.each do |client|
    firewall_rule "Memcached allow #{client}" do
      port      listen_port
      position  1 # Make sure it's above the deny
      interface node['rax']['memcached']['interface']
      source    client
      direction :in
      action    :allow
    end
  end

when 'rhel'
  # TODO: Work in progress. The default action is to append, and there does not
  # appear to be a way to provide line numbers with this cookbook.
  %w(tcp udp).each do prot
    clients.each do |client|
      iptables_ng_rule "Memcached allow #{client}" do
        chain      'INPUT'
        table      'filter'
        ip_version 4
        rule       "-s #{client} -p #{prot} --dport #{listen_port} -j ACCEPT"
        action     :create_if_missing
      end
    end

    iptables_ng_rule 'Deny all #{prot} connections to memcached by default' do
      name       'Memcached'
      chain      'INPUT'
      table      'filter'
      ip_version 4
      rule       "-s #{client} -p #{prot} --dport #{listen_port} -j DROP"
      action     :create_if_missing
    end
  end

end
