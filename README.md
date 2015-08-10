[![Circle CI](https://circleci.com/gh/rackspace-orchestration-templates/wordpress-multi/tree/master.png?style=shield)](https://circleci.com/gh/rackspace-orchestration-templates/wordpress-multi/tree/master)

Description
===========

foo This is a template for deploying a [WordPress](http://wordpress.org/) across
multiple servers. By default, this template will create a Cloud Load Balancer,
a database server, an admin/master node, and a web node. Content will be kept
in sync across the admin/master node and the remaining nodes leveraging lsyncd.
This template is leveraging [chef-solo](http://docs.opscode.com/chef_solo.html)
to setup the server.

Requirements
============
* A Heat provider that supports the following:
  * OS::Heat::ChefSolo
  * OS::Heat::RandomString
  * Rackspace::Cloud::LoadBalancer
  * OS::Heat::ResourceGroup
  * Rackspace::Cloud::Server
  * OS::Nova::KeyPair
* An OpenStack username, password, and tenant id.
* [python-heatclient](https://github.com/openstack/python-heatclient)
`>= v0.2.8`:

```bash
pip install python-heatclient
```

We recommend installing the client within a [Python virtual
environment](http://www.virtualenv.org/).

Example Usage
=============
Here is an example of how to deploy this template using the
[python-heatclient](https://github.com/openstack/python-heatclient):

```
heat --os-username <OS-USERNAME> --os-password <OS-PASSWORD> --os-tenant-id \
  <TENANT-ID> --os-auth-url https://identity.api.rackspacecloud.com/v2.0/ \
  stack-create WordPress-Multi -f wordpress-multi-server.yaml \
  -P domain=example.org
```

* For UK customers, use `https://lon.identity.api.rackspacecloud.com/v2.0/` as
the `--os-auth-url`.

Optionally, set environmental variables to avoid needing to provide these
values every time a call is made:

```
export OS_USERNAME=<USERNAME>
export OS_PASSWORD=<PASSWORD>
export OS_TENANT_ID=<TENANT-ID>
export OS_AUTH_URL=<AUTH-URL>
```

Parameters
==========
Parameters can be replaced with your own values when standing up a stack. Use
the `-P` flag to specify a custom parameter.

* `username`: Username for system, database, and WordPress logins. (Default:
  wp_user)
* `domain`: Domain to be used with this WordPress site (Default: example.com)
* `wp_web_server_flavor`: Cloud Server size to use on all of the additional web
  nodes. (Default: 2 GB Performance)
* `wp_web_server_hostnames`: Hostname to use for all additional WordPress web
  nodes (Default: WordPress-Web%index%)
* `image`: Required: Server image used for all servers that are created as a
  part of this deployment. (Default: Ubuntu 12.04 LTS (Precise Pangolin))
* `child_template`: Location of the child template to use for the WordPress web
  servers (Default:
  https://raw.githubusercontent.com/rackspace-orchestration-templates/wordpress-multi/master/wordpress-web-server.yaml)
* `load_balancer_hostname`: Hostname for the Cloud Load Balancer (Default:
  WordPress-Load-Balancer)
* `prefix`: Prefix to use for database table names. (Default: wp_)
* `database_server_flavor`: Cloud Server size to use for the database server.
  Sizes refer to the amount of RAM allocated to the server. (Default: 4 GB
  Performance)
* `kitchen`: URL for the kitchen to use, fetched using git (Default:
  https://github.com/rackspace-orchestration-templates/wordpress-multi)
* `database_server_hostname`: Hostname to use for your WordPress Database
  Server (Default: WordPress-Database)
* `database_name`: WordPress database name (Default: wordpress)
* `wp_master_server_hostname`: Hostname to use for your WordPress web-master
  server. (Default: WordPress-Master)
* `wp_web_server_count`: Number of web servers to deploy in addition to the
  web-master (Default: 1)
* `version`: Version of WordPress to install (Default: 3.9.1)
* `wp_master_server_flavor`: Cloud Server size to use for the web-master node.
  The size should be at least one size larger than what you use for the web
  nodes. This server handles all admin calls and will ensure files are synced
  across all other nodes. (Default: 2 GB Performance)
* `chef_version`: Version of chef client to use (Default: 11.12.8)

Outputs
=======
Once a stack comes online, use `heat output-list` to see all available outputs.
Use `heat output-show <OUTPUT NAME>` to get the value fo a specific output.

* `private_key`: SSH private that can be used to login as root to the server.
* `load_balancer_ip`: Public IP address of the Load Balancer
* `database_server_ip`: Public IP of Database Server
* `wordpress_web_master_ip`: WordPress web-master server IP
* `wordpress_web_ips`: List of WordPress web server IPs
* `wordpress_user`: Username for database, system, and WordPress logins
* `wordpress_password`: Password for the `wordpress_user`
* `mysql_root_password`: Root password for MySQL

For multi-line values, the response will come in an escaped form. To get rid of
the escapes, use `echo -e '<STRING>' > file.txt`. For vim users, a substitution
can be done within a file using `%s/\\n/\r/g`.

Stack Details
=============
If you provided a domain name that is associated with your Rackspace Cloud
account and chose to create DNS records, you will be able to navigate to the
provided domain name in your browser. If DNS has not been configured yet,
please refer to this
[documentation](http://www.rackspace.com/knowledge_center/article/how-do-i-modify-my-hosts-file)
on how to setup your hosts file to allow your browser to access your deployment
via domain name. Please note: some applications like WordPress may not work
properly unless accessed via domain name.

A system user of 'wp_user' or the username you provided as a part of your
deployment has been created. This user can be used to SCP, SFTP, or FTP
content over to your site. We recommend using SCP or any encrypted protocol.
Clear text protocols such as FTP could inadvertently expose your user
credentials.

WordPress is installed in /var/www/vhosts/wordpress/ and served by
[Apache](http://httpd.apache.org/). The web site configuration is in
/etc/apache2/sites-enabled. The configuration file will be named using the
domain name used as a part of this deployment (for example, domain.com.conf).

In order to significantly improve performance, Apache has been moved to run on
port 8080, and [Varnish](https://www.varnish-cache.org/) is listening on port
80. Varnish will cache content served by WordPress, store it in memory, and
then serve it from memory if any subsequent requests are made for the same
content. A special configuration file build for WordPress is in place.
The configuration can be found in /etc/varnish. Be aware that Varnish can
cause issues with certain WordPress plugins. A pass line may need to be added

[Lsyncd](https://code.google.com/p/lsyncd/) has been in installed to sync
static content across the front end servers. All new content will be published
to the master node and then synced across with lsync to the other web nodes.
When uploading content while migrating a site, you'll only need to upload the
content to the master node. The configuration for lsync can be found in
/etc/lsyncd.

[vsftpd](https://security.appspot.com/vsftpd.html) has been installed to allow
you FTP access to the content of your site. As mentioned earlier, you can use
the WordPress username and password provided as the credentials for FTP. Only
the admin/master node will have vsftpd installed.  Lsyncd will handle syncing
any new content to web nodes.

[MySQL](http://www.mysql.com/) is the database backend used in this deployment.
The MySQL root password is included in the outs section of this deployment.
If you do lose the password, it is also available in /root/.my.cnf. MySQL
backups are performed locally by [Holland](http://wiki.hollandbackup.org/). The
backups will be stored in /var/lib/mysqlbackup.

Updating WordPress
==================
If you'd like to update WordPress to the newest version, you can leverage the
[One-click
Update](http://codex.wordpress.org/Updating_WordPress#One-click_Update) now
available through the web interface.  This is the simplest, most pain free way
to upgrade your installation.  Keeping your installation up to date is
important for maintaining site security.

Migrating an Existing Site
==========================
If you'd like to move your existing site to this deployment, there are plugins
available such as [duplicator](http://wordpress.org/plugins/duplicator/) or [WP
Migrate DB](http://wordpress.org/plugins/wp-migrate-db/) that can help ease the
migration process.  This will give you a copy of the database that you can
import into this deployment.  There are a number of other tools to help with
this process.  Static content that is stored on the filesystem will need to be
moved manually.

Contributing
============
There are substantial changes still happening within the [OpenStack
Heat](https://wiki.openstack.org/wiki/Heat) project. Template contribution
guidelines will be drafted in the near future.

License
=======
```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
