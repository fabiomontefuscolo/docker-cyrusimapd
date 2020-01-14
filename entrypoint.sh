#!/bin/bash
set +x

if [ -n "${CYRUS_PASSWORD}" ];
then
    echo "cyrus:${CYRUS_PASSWORD}" | chpasswd
fi

source /etc/sysconfig/saslauthd
/usr/sbin/saslauthd -m $SOCKETDIR -a $MECH $FLAGS

exec "$@"