# coding: utf-8
#
# Cookbook Name:: rax-wordpress
# Attribute:: x509
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

default['rax']['x509']['rsa'] = 4096
default['rax']['x509']['days'] = 365 * 5
default['rax']['x509']['cn'] = node['apache']['domain']
default['rax']['x509']['o'] = 'Example'
default['rax']['x509']['c'] = 'US'
default['rax']['x509']['st'] = 'TX'
default['rax']['x509']['l'] = 'San Antonio'

default['rax']['x509']['key_file'] = File.join(node['rax']['apache']['ssl']['keypath'],
                                        "#{node['rax']['apache']['domain']}.key")
default['rax']['x509']['cert_file'] = File.join(node['rax']['apache']['ssl']['certpath'],
                                         "#{node['rax']['apache']['domain']}.crt")
