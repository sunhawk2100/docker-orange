#!/bin/bash
ORANGE_CONF="/usr/local/orange/conf/orange.conf"

# DNS resolve for nginx
dnsmasq

# if command starts with option, init mysql
if [[ "X${ORANGE_DATABASE}" != "X" ]]; then
    sed -i "s/\"host\": \"127.0.0.1\"/\"host\": \"${ORANGE_HOST}\"/g" ${ORANGE_CONF}
    sed -i "s/\"port\": \"3306\"/\"port\": \"${ORANGE_PORT}\"/g" ${ORANGE_CONF}
    sed -i "s/\"database\": \"orange\"/\"database\": \"${ORANGE_DATABASE}\"/g" ${ORANGE_CONF}
    sed -i "s/\"user\": \"root\"/\"user\": \"${ORANGE_USER}\"/g" ${ORANGE_CONF}
    sed -i "s/\"password\": \"\"/\"password\": \"${ORANGE_PWD}\"/g" ${ORANGE_CONF}
fi

# Nginx conf modify
if cat ${ORANGE_CONF} | grep "www www" > /dev/null
then
    sed -i "s/worker_processes  4;/user www www;\nworker_processes  4;/g" ${ORANGE_CONF}
fi
sed -i "s/resolver 114.114.114.114;/resolver 127.0.0.1 ipv6=off;/g" ${ORANGE_CONF}
sed -i "s/lua_package_path '..\/?.lua;\/usr\/local\/lor\/?.lua;;';/lua_package_path '\/usr\/local\/orange\/?.lua;\/usr\/local\/lor\/?.lua;;';/g" ${ORANGE_CONF}
sed -i "s/listen       80;/listen       8888;/g" ${ORANGE_CONF}

/usr/local/bin/orange start