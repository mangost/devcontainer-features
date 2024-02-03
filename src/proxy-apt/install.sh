#!/bin/bash

# check if file exist
if [ -f /etc/apt/apt.conf.d/01proxy ]; then
    echo "File /etc/apt/apt.conf.d/01proxy already exist"
    exit 0
fi

# Set proxy for apt using options or environment variables
echo "Acquire::http::Proxy \"${http_proxy}\";" > /etc/apt/apt.conf.d/01proxy
echo "Acquire::https::Proxy \"${https_proxy}\";" >> /etc/apt/apt.conf.d/01proxy

# output
echo "Proxy for apt set to:"
cat /etc/apt/apt.conf.d/01proxy