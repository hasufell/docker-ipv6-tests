#!/bin/bash

die() {
        echo $@
        exit 1
}

docker stop hasufell/nginx-proxy
docker rm hasufell/nginx-proxy

docker stop hasufell/docker-postfix-dovecot
docker rm hasufell/docker-postfix-dovecot

