#!/bin/bash
set +x

if [ -n "${CYRUS_PASSWORD}" ];
then
    echo "cyrus:${CYRUS_PASSWORD}" | chpasswd
fi

exec "$@"