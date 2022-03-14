#!/bin/bash

set -e

if [ "$1" = "theta" ] || [ "$1" = "thetacli" ]; then
    mkdir -p /theta_mainnet/guardian_mainnet/node
    chown -R theta /theta_mainnet/guardian_mainnet/node
    ulimit -n 4096
    exec gosu theta "$@"
fi

exec "$@"
