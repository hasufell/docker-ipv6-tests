#!/bin/bash

docker build -t hasufell/docker-postfix-dovecot dockermail/core
docker build -t hasufell/nginx-proxy nginx-proxy
docker build -t hasufell/phantomjs phantomjs
