# coding: utf-8
#
# Cookbook Name:: rax-wordpress
# Attribute:: lsyncd.rb
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

default['rax']['lsyncd']['ssh']['pub'] = nil
default['rax']['lsyncd']['ssh']['private_key'] = nil
default['rax']['lsyncd']['clients'] = []
default['rax']['lsyncd']['excludes_file'] = '/etc/lsyncd/lsyncd.exclusions'
default['rax']['lsyncd']['exclusions'] = ['.ssh']

pub_keypath = File.join(node['wordpress']['dir'], '.ssh/id_rsa')

default['rax']['lsyncd']['rsync_opts'] = ['-rlpgoDvz', '-e',
  "/usr/bin/ssh -i #{pub_keypath} -o StrictHostKeyChecking=no" ]
