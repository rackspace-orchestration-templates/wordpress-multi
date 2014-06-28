from fabric.api import env, task
from envassert import detect, file, package, port, process, service


@task
def mysql():
    env.platform_family = detect.detect()

    packages = ["holland", "mysql-server"]
    for pkg in packages:
        assert package.installed(pkg)

    assert port.is_listening(3306)
    assert process.is_up("mysqld")
    assert service.is_enabled("memcached")

    root_my_cnf = "/root/.my.cnf"
    assert file.exists(root_my_cnf)
    assert file.mode_is(root_my_cnf, 600)
    assert file.owner_is(root_my_cnf, "root")


@task
def memcached():
    env.platform_family = detect.detect()

    assert package.installed("memcached")
    assert port.is_listening(11211)
    assert process.is_up("memcached")
    assert service.is_enabled("memcached")
