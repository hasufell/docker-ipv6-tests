#!/bin/bash

pushd dockermail/core > /dev/null
docker build -t hasufell/docker-postfix-dovecot .
popd > /dev/null

pushd nginx-proxy > /dev/null
docker build -t hasufell/nginx-proxy .
popd > /dev/null

pushd phantomjs > /dev/null
docker build -t hasufell/phantomjs .
popd > /dev/null
