#!/bin/bash

die() {
        echo $@
        exit 1
}

docker stop nginx-proxy
docker rm nginx-proxy

docker stop dockermail
docker rm dockermail

