# coding: utf-8
#
# Cookbook Name:: rax-wordpress
# Recipe:: varnish-firewall
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

# Allow all web nodes to access this server on port 8080

listen_ports = [ 8080 ]

listen_ports.each do |listen_port|
  node['rax']['lsyncd']['clients'].each do |client|
    case node['platform_family']
    when 'debian'
      firewall_rule "Firewall rule, tcp/#{listen_port}" do
        port      listen_port.to_i
        source    client
        protocol  :tcp
        direction :in
        action    :allow
      end
    when 'rhel'
      iptables_ng_rule 'Firewall rule, tcp/#{listen_port}' do
        name       'WordPress'
        chain      'INPUT'
        table      'filter'
        ip_version [4, 6]
        rule       "-s #{client} -p tcp --dport #{listen_port} -j ACCEPT"
        action     :create_if_missing
      end
    end
  end
end
