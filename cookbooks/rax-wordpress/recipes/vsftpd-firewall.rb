# coding: utf-8
#
# Cookbook Name:: rax-wordpress
# Recipe:: vsftpd-firewall
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

# Single ports to allow through

listen_ports = [ 21 ]

# Port ranges to allow through for services like pasv ftp
listen_ranges = [[node['vsftpd']['pasv_min_port'],
                  node['vsftpd']['pasv_max_port']]]

# Handle single ports first
listen_ports.each do |listen_port|
  case node['platform_family']
  when 'debian'
    firewall_rule "Firewall rule, tcp/#{listen_port}" do
      port      listen_port.to_i
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
      rule       "-p tcp --dport #{listen_port} -j ACCEPT"
      action     :create_if_missing
    end
  end
end

# Handle port ranges
listen_ranges.each do |listen_range|
  case node['platform_family']
  when 'debian'
    firewall_rule "Firewall range, tcp/#{listen_range.to_s}" do
      port_range (listen_range.first .. listen_range.last)
      protocol   :tcp
      direction  :in
      action     :allow
    end
  when 'rhel'
    iptables_ng_rule 'Firewall range, tcp/#{listen_range.to_s}' do
      name       'WordPress'
      chain      'INPUT'
      table      'filter'
      ip_version [4, 6]
      rule       "-p tcp --dport #{listen_range.first}:#{listen_range.last} -j ACCEPT"
      action     :create_if_missing
    end
  end
end
