#
# Cookbook Name:: hollandbackup
# Attributes:: repository
#
# Copyright 2012-2014, David Joos
#

case node['platform']
  when 'ubuntu'
    default['hollandbackup']['repository']['distro'] = "xUbuntu_#{node['platform_version']}"
  when 'centos'
    default['hollandbackup']['repository']['distro'] = "CentOS_CentOS-#{node['platform_version'].to_i}"
  when 'debian'
	default['hollandbackup']['repository']['distro'] = "Debian_#{node['platform_version'].to_i}.0"
  when 'rhel'
	default['hollandbackup']['repository']['distro'] = "RedHat_RHEL-#{node['platform_version'].to_i}"
end
