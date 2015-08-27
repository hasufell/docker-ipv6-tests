#!/bin/bash

die() {
	echo $@
	exit 1
}

[[ -e /var/lib/dockermail ]] \
	|| die "set up the configuration in /var/lib/dockermail, see the README"


# start nginx mail proxy, named 'nginx-proxy'
docker run --name=nginx-proxy -ti -d \
	-p 80:80 \
	-p 443:443 \
	-p 444:444 \
	-p 445:445 \
	-p 25:25 \
	-p 110:110 \
	-p 995:995 \
	-p 143:143 \
	-p 993:993 \
	-p 2525:2525 \
	-p 465:465 \
	-p 587:587 \
	-v `pwd`/nginx-proxy/config/www-tmp:/var/www/tmp:ro \
	nginx-proxy || die "failed to start nginx mail proxy!"

sleep 3

# get nginx-proxy ips
nginx_ipv4_addr="$(docker inspect nginx-proxy | grep IPAddress | cut -d \" -f 4)/32"
nginx_ipv6_addr="[$(docker inspect nginx-proxy | grep GlobalIPv6Address | cut -d \" -f 4)]/128"

echo -n "127.0.0.0/8 [::1]/128 ${nginx_ipv4_addr} ${nginx_ipv6_addr}" > /var/lib/dockermail/settings/postfix-networks || die "failed to set allowed postfix networks"

# start mail-container, named 'dockermail'
docker run --name=dockermail -t -i -d \
	--log-driver=syslog --log-opt syslog-tag="mailer" \
	-v /var/lib/dockermail/settings:/mail_settings \
	-v /var/lib/dockermail/vmail/:/vmail \
	dockermail \
	|| die "failed to start mail-container!"

# set the container address used by the nginx-proxy during runtime
dockermail_ipv6_addr="$(docker inspect dockermail \
		| grep GlobalIPv6Address \
		| cut -d \" -f 4)"
echo -n "${dockermail_ipv6_addr}" > ./nginx-proxy/config/www-tmp/addr \
	|| die "failed to set address for the nginx auth script"
