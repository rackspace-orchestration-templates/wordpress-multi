# coding: utf-8
#
# Cookbook Name:: rax-wordpress
# Recipe:: lsyncd-client
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

include_recipe 'rax-wordpress::user'

if node['rax']['lsyncd']['ssh']['pub']
  directory File.join(node['wordpress']['dir'], '.ssh') do
    owner node['rax']['wordpress']['user']['name']
    group node['rax']['wordpress']['user']['group']
    mode '0700'
    action :create
  end

  file File.join(node['wordpress']['dir'], '.ssh/authorized_keys') do
    content node['rax']['lsyncd']['ssh']['pub']
    owner node['rax']['wordpress']['user']['name']
    group node['rax']['wordpress']['user']['group']
    mode '0644'
    action :create
  end
end
