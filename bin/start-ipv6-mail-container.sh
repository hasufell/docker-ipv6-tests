#!/bin/bash

die() {
	echo $@
	exit 1
}

[[ -e /var/lib/dockermail ]] || die "set up the configuration in /var/lib/dockermail, see the README"

docker stop dockermail-ipv6
docker rm dockermail-ipv6
docker run --name=dockermail-ipv6 -t -i -d -v /dev/log:/dev/log -v /var/lib/dockermail/settings:/mail_settings -v /var/lib/dockermail/vmail/:/vmail hasufell/docker-postfix-dovecot

ipv6_addr="$(docker inspect dockermail-ipv6 | grep GlobalIPv6Address | cut -d \" -f 4)"

echo -n "${ipv6_addr}" > ./nginx-proxy/config/www-tmp/addr || die "failed to set address for the nginx auth script"
