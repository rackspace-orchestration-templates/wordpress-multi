# coding: utf-8
# Cookbook Name:: rax-wordpress
# Attribute:: memcache
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

default[:rax][:memcache][:server] = '127.0.0.1'
default[:rax][:memcache][:port] = node['memcached']['port']
default[:rax][:memcache][:persistent] = 1
default[:rax][:memcache][:weight] = 1
default[:rax][:memcache][:timeout] = 1
default[:rax][:memcache][:retry_interval] = 15
default[:rax][:memcache][:php_conf_dir] = '/etc/php5/apache2'
