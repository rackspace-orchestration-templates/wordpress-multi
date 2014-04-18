# coding: utf-8
#
# Cookbook Name:: rax-wordpress
# Recipe:: apache-prep
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

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

node.set['apache']['contact'] = "root@#{node[:hostname]}"

# Lets figure maxclients depending on server size
maxclients = node['memory']['total'].to_i / 15_000
maxspareservers = Math.sqrt(maxclients) + 2
minspareservers = maxspareservers / 2

# Prefork Attributes
node.set['apache']['prefork']['startservers'] = 4
node.set['apache']['prefork']['minspareservers'] = minspareservers.to_i
node.set['apache']['prefork']['maxspareservers'] = maxspareservers.to_i
node.set['apache']['prefork']['serverlimit'] = maxclients.to_i
node.set['apache']['prefork']['maxclients'] = maxclients.to_i
node.set['apache']['prefork']['maxrequestsperchild'] = 1_000
