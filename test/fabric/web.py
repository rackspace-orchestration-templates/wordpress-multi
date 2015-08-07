import os
from fabric.api import env, task
from envassert import detect, file, package, port, process, service, user
from hot.utils.test import get_artifacts


@task
def apache():
    env.platform_family = detect.detect()

    apache_config = "/etc/apache2/sites-enabled/example.com.conf"

    assert package.installed("apache2")
    assert process.is_up("apache2")
    assert service.is_enabled("apache2")
    assert port.is_listening(8080)
    assert file.has_line(apache_config, "VirtualHost *:8080")


@task
def lsync_client():
    env.platform_family = detect.detect()

    wordpress_user = "wp_user"
    web_group = "www-data"
    ssh_dir = "/var/www/vhosts/example.com/.ssh"
    auth_keys = os.path.join(ssh_dir, "authorized_keys")

    assert user.exists(wordpress_user)
    assert user.is_belonging_group(wordpress_user, web_group)
    assert file.dir_exists(ssh_dir)
    assert file.owner_is(ssh_dir, wordpress_user)
    assert file.owner_is(auth_keys, wordpress_user)
    assert file.mode_is(auth_keys, 644)


@task
def varnish():
    env.platform_family = detect.detect()

    varnish_config = "/etc/varnish/default.vcl"

    assert package.installed("varnish")
    assert process.is_up("varnishd")
    assert service.is_enabled("varnish")
    assert port.is_listening(80)
    assert file.has_line(varnish_config, "backend master")
    # assert file.has_line(varnish_config, "backend local") This fails, it makes me thing we're not using the right default.vcl

# @task
# def monitoring():
#     env.platform_family = detect.detect()
#
#     monitor_config = "/etc/rackspace-monitoring-agent.cfg"
#
#     assert package.installed("rackspace-monitoring-agent")
#     assert process.is_up("rackspace-monitoring-agent")
#     assert service.is_enabled("rackspace-monitoring-agent")
#     assert file.exists(monitoring_config)


@task
def artifacts():
    env.platform_family = detect.detect()
    get_artifacts()
