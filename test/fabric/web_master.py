import os
from retrying import retry
from fabric.api import env, task
from envassert import detect, file, package, port, process, service, user
from hot.utils.test import get_artifacts


@task
def apache():
    env.platform_family = detect.detect()

    apache_config = "/etc/apache2/sites-enabled/wordpress.conf"
    web_user = "www-data"
    www_dir = "/var/www/vhosts/example.com"

    assert package.installed("apache2")
    assert process.is_up("apache2")
    assert service.is_enabled("apache2")
    assert port.is_listening(8080)
    assert file.has_line(apache_config, "VirtualHost *:8080")
    assert file.owner_is(www_dir, web_user)


@retry(stop_max_attempt_number=5, wait_fixed=1000)
def check_lsync_up():
  assert process.is_up("lsyncd"), 'lsyncd is not up'


@task
def lsyncd():
    env.platform_family = detect.detect()

    wordpress_user = "wp_user"
    web_group = "www-data"
    ssh_dir = "/var/www/vhosts/example.com/.ssh"
    private_key = os.path.join(ssh_dir, "id_rsa")

    assert package.installed("lsyncd"), 'lsyncd is not installed'
    check_lsync_up()
    assert service.is_enabled("lsyncd"), 'lsyncd is not enabled'
    assert user.exists(wordpress_user), 'wp_user user does not exist'
    assert user.exists('wp_user').get('passwd') != '!', 'wp_user pass missing'
    assert user.is_belonging_group(wordpress_user, web_group), 'wp_user does belong to correct group'
    assert file.dir_exists(ssh_dir), 'ssh directory does not exist'
    assert file.owner_is(ssh_dir, wordpress_user), 'wp_user does not own ssh directory'
    assert file.owner_is(private_key, wordpress_user), 'wp_user does not own ssh key'
    assert file.mode_is(private_key, 600), 'ssh key is not set to correct mode'


@task
def varnish():
    env.platform_family = detect.detect()

    varnish_config = "/etc/varnish/default.vcl"

    assert package.installed("varnish")
    assert process.is_up("varnishd")
    assert service.is_enabled("varnish")
    assert port.is_listening(80)
    assert file.has_line(varnish_config, "backend master")
    assert file.has_line(varnish_config, "backend local")


@task
def monitoring():
    env.platform_family = detect.detect()

    monitor_config = "/etc/rackspace-monitoring-agent.cfg"

    assert package.installed("rackspace-monitoring-agent")
    assert process.is_up("rackspace-monitoring-agent")
    assert service.is_enabled("rackspace-monitoring-agent")
    assert file.exists(monitoring_config)


@task
def artifacts():
    env.platform_family = detect.detect()
    get_artifacts()
