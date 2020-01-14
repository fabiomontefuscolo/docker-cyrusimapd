#!/bin/bash
set +x

source /etc/sysconfig/saslauthd
/usr/sbin/saslauthd -m $SOCKETDIR -a $MECH $FLAGS

exec "$@"