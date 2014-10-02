default[:rax_mysql_tunables][:config_options][:mysqld]['innodb-buffer-pool-size'] = "#{(node['memory']['total'].to_i * 0.6 ).floor * 1024}"
