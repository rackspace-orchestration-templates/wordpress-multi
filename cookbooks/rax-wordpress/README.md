rax-wordpress
=============
Note: This is still a work in progress. It is lacking a lot in terms of
documentation and styling.

This is cookbook with wrapper recipes to complete Rackspace's customer
WordPress deployment. We aim to use as many community and public cookbooks as
possible to make this happen. This cookbook can be used to stand up a server
with Apache, PHP, MySQL, Varnish, vsftpd, hollandbackup, and lsync installed.
It will create a local user that can be used to move content via scp, sftp, or
ftp/ftps.

todo
====
* Provide documentation mapping out how attributes are consumed.
* Add tests
* Adding contribution guidelines
* Add support for CentOS

requirements
============
This cookbook is designed to be used on a Rackspace Cloud Server. All cookbooks
should work with Chef 11+ on Ubuntu.

recipes
=======
#### apache-prep
Updates parameters for Apache automatically based on the size of the server.

#### apache
Updates the WordPress Apache configuration in case the port used is not 80.
Creates SSL configuration if a cert and key are provided.

#### apache-prep
Adjusts Apache attributes based on the size of a server.  This should be put in
before `wordpress::default` in your run list.

#### default
Does nothing

#### firewall
Opens the firewall for http and potentially https traffic, typically run last.

#### lsyncd-client
Creates the .ssh directory for the WordPress user, installs the public SSH key.

#### lsyncd
Creates the .ssh directory for the WordPress user, installs the SSH private
key.

#### mysql
Sets up /root/.my.cnf

#### user
Creates the admin user account, allowing the user to bypass the web installer.

#### varnish
Swaps out the default vcl with a vcl tailored for use with WordPress.

#### vsftpd
Handles additional configuration of vsftpd. Setup will setup FTPS and will
allow both FTP and FTPS by default.

#### wp-setup
Performs the initial install steps and creates the WordPress admin user.

#### x509
Installs SSL certs or generates self-signed certs if none are provided.
