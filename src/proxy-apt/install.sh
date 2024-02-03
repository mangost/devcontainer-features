#!/bin/sh

# check if file exist
if [ -f /etc/apt/apt.conf.d/95proxy ]; then
    echo "File /etc/apt/apt.conf.d/95proxy already exist"
    exit 0
fi

if [ -z "${HTTP_PROXY}" ] && [ -z "${HTTPS_PROXY}" ]; then
    echo "HTTP_PROXY and HTTPS_PROXY are not set"
    exit 1
fi

# Set proxy for apt using options or environment variables
echo "Acquire::http::Proxy \"${HTTP_PROXY}\";" > /etc/apt/apt.conf.d/95proxy
echo "Acquire::https::Proxy \"${HTTPS_PROXY}\";" >> /etc/apt/apt.conf.d/95proxy

# output
echo "Proxy for apt set to:"
cat /etc/apt/apt.conf.d/95proxy

env > /etc/debug_env