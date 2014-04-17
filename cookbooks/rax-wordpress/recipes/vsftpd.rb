# coding: utf-8
#
# Cookbook Name:: rax-wordpress
# Recipe:: vsftpd
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

include_recipe 'rax-wordpress::x509'

# These are options that are not available attributes in the community cookbook
additional_options = ['force_local_logins_ssl=NO', 'force_local_data_ssl=NO']

additional_options.each do |option|
  execute "Add #{option} to vsftpd configuration" do
    command "echo #{option} >> /etc/vsftpd.conf"
    not_if "grep '^#{option}$' /etc/vsftpd.conf"
    notifies :restart, 'service[vsftpd]', :delayed
  end
end
