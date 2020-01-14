#!/bin/bash
set -x

CERT_FILE=$(awk '/^tls_server_cert:/{ print $2 }' /etc/imapd.conf)
CERT_KEY_FILE=$(awk '/^tls_server_key:/{ print $2 }' /etc/imapd.conf)
CA_FILE=$(awk '/^tls_client_ca_file:/{ print $2 }' /etc/imapd.conf)

if [ ! -e "${CERT_FILE}" ] || [ ! -e "${CERT_KEY_FILE}" ] || [ ! -e "${CA_FILE}" ];
then
    /usr/bin/sscg                          \
        --package cyrus-imapd              \
        --cert-file "${CERT_FILE}"         \
        --cert-key-file "${CERT_KEY_FILE}" \
        --ca-file "${CA_FILE}"
fi

if [ -n "${CYRUS_PASSWORD}" ];
then
    echo "cyrus:${CYRUS_PASSWORD}" | chpasswd
fi

exec "$@"