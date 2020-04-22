#!/bin/bash
set -x

if [ ! -e "/etc/imapd.conf" ];
then
    cat /etc/imapd.conf.d/*.conf > /etc/imapd.conf
fi

if [ ! -e "/etc/cyrus.conf" ];
then
    cat /etc/cyrus.conf.d/*.conf > /etc/cyrus.conf
fi

if [ ! -e "/etc/saslauthd.conf" ];
then
    cat /etc/saslauthd.conf.d/*.conf > /etc/saslauthd.conf
fi

if [ -n "${CYRUS_PASSWORD}" ];
then
    echo "cyrus:${CYRUS_PASSWORD}" | chpasswd
fi

if [ -e "${SYSLOG_SOCK}" ];
then
    ln -sf "${SYSLOG_SOCK}" /dev/log
else
    ln -sf /run/rsyslog/dev/log /dev/log
fi

mkdir -p /run/cyrus/socket
chown -R cyrus:cyrus /run/cyrus

cert_file=$(awk '/^tls_server_cert:/{ print $2 }' /etc/imapd.conf)
cert_key_file=$(awk '/^tls_server_key:/{ print $2 }' /etc/imapd.conf)
ca_file=$(awk '/^tls_client_ca_file:/{ print $2 }' /etc/imapd.conf)

if [ ! -e "${cert_file}" ] || [ ! -e "${cert_key_file}" ] || [ ! -e "${ca_file}" ];
then
    /usr/bin/sscg                          \
        --package cyrus-imapd              \
        --cert-file "${cert_file}"         \
        --cert-key-file "${cert_key_file}" \
        --ca-file "${ca_file}"

    chown cyrus ${cert_file}
    chown cyrus ${cert_key_file}
    chown cyrus ${ca_file}
fi

"$@"
