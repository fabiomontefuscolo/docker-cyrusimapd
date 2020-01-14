FROM centos:8
LABEL author "Fabio Montefuscolo <fabio.montefuscolo@gmail.com>"

ENV CYRUS_VERBOSE=1

RUN yum install -y                                                      \
        cyrus-imapd                                                     \
        cyrus-imapd-utils                                               \
        cyrus-sasl                                                      \
        cyrus-sasl-gs2                                                  \
        cyrus-sasl-sql                                                  \
        cyrus-sasl-ldap                                                 \
        cyrus-sasl-scram                                                \
        cyrus-sasl-ntlm                                                 \
        cyrus-sasl-gssapi                                               \
        cyrus-sasl-plain                                                \
        cyrus-sasl-devel                                                \
        cyrus-sasl-lib                                                  \
        cyrus-sasl-md5                                                  \
        glibc-langpack-en                                               \
    && yum --enablerepo='*' clean all                                   \
    && /usr/bin/sscg                                                    \
        --package cyrus-imapd                                           \
        --cert-file /etc/pki/cyrus-imapd/cyrus-imapd.pem                \
        --cert-key-file /etc/pki/cyrus-imapd/cyrus-imapd-key.pem        \
        --ca-file /etc/pki/cyrus-imapd/cyrus-imapd-ca.pem               \
    && ln -sf                                                           \
        /usr/lib/systemd/system/cyrus-imapd.service                     \
        /etc/systemd/system/multi-user.target.wants/cyrus-imapd.service \
    && ln -sf                                                           \
        /usr/lib/systemd/system/saslauthd.service                       \
        /etc/systemd/system/multi-user.target.wants/saslauthd.service

EXPOSE 110 119 143 406 563 993 995 1109 2003 2004 2005 3905 4190

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/sbin/init"]
