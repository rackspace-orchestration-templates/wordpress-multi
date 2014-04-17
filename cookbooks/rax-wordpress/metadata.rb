name    'rax-wordpress'
version '0.1.0'
license 'Apache 2.0'

%w{ apache database firewall iptables-ng lsyncd mysql varnish wordpress }.each do |cb|
  depends cb
end

%w{ ubuntu debian centos rhel }.each do |os|
  supports os
end
