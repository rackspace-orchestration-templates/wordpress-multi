
import os
import re
import yaml

from colorama import Fore, Style, init, deinit
from github3 import GitHub
from pkg_resources import parse_version


def latest_template_wordpress_version():
    template = yaml.load(open('wordpress-multi-server.yaml'))
    straints = template.get('parameters').get('version').get('constraints')
    versions = []
    for constraint in straints:
        allowed_values = constraint.get('allowed_values')
        if allowed_values:
            versions.extend(allowed_values)
    highest_supported_version = '0.0.0'
    for version in versions:
        if parse_version(version) > parse_version(highest_supported_version):
            highest_supported_version = version
    print "The latest version the template supports is {}.".format(
        highest_supported_version)
    return highest_supported_version


def check_for_newer_wp_release():
    init()
    most_recent_version_supported = latest_template_wordpress_version()
    g = GitHub(token=os.environ.get('GITHUB_TOKEN'))
    repo = g.repository('wordpress', 'wordpress')
    tags = [t.name for t in repo.tags()]
    version = parse_version(most_recent_version_supported)
    for tag in tags:
        if not re.search('[Bb]eta', tag):
            assert version >= parse_version(tag), \
                (Fore.RED + Style.BRIGHT + \
                 '\nIt would seem there is a newer version of '
                 'WordPress available: {}-- update the template '
                 'to support it!\n' + Fore.RESET + Style.RESET_ALL).format(tag)

    print Fore.GREEN + Style.BRIGHT +                                        \
        "Looks like {} is the most".format(most_recent_version_supported),   \
        "recent version of WordPress. The template supports that, so we're good!" + \
        "\n" + Fore.RESET + Style.RESET_ALL
    deinit()

if __name__ == "__main__":
    check_for_newer_wp_release()
