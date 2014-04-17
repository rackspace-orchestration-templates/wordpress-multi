# coding: utf-8
#
# Cookbook Name:: rax-wordpress
# Recipe:: mysql-firewall
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

iface = 'eth1'

case node['platform_family']
when 'debian'
  firewall_rule "Firewall rule, tcp/#{node['mysql']['port']}" do
    port      node['mysql']['port'].to_i
    interface iface
    protocol  :tcp
    direction :in
    action    :allow
  end
when 'rhel'
  iptables_ng_rule "Firewall rule, tcp/#{node['mysql']['port']}" do
    name       'MySQL'
    chain      'INPUT'
    table      'filter'
    ip_version [4, 6]
    rule       "-i #{iface}-p tcp --dport #{node['mysql']['port']} -j ACCEPT"
    action     :create_if_missing
  end
end
