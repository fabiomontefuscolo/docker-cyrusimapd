FROM centos:8
LABEL author "Fabio Montefuscolo <fabio.montefuscolo@gmail.com>"

RUN yum install -y                                                \
        cyrus-imapd                                               \
        cyrus-imapd-utils                                         \
        cyrus-sasl                                                \
        cyrus-sasl-gs2                                            \
        cyrus-sasl-sql                                            \
        cyrus-sasl-ldap                                           \
        cyrus-sasl-scram                                          \
        cyrus-sasl-ntlm                                           \
        cyrus-sasl-gssapi                                         \
        cyrus-sasl-plain                                          \
        cyrus-sasl-devel                                          \
        cyrus-sasl-lib                                            \
        cyrus-sasl-md5                                            \
        glibc-langpack-en                                         \
    && yum --enablerepo='*' clean all                             \
    && mkdir -p /etc/imapd.conf.d                                 \
    && mkdir -p /etc/cyrus.conf.d                                 \
    && mkdir -p /etc/saslauthd.conf.d                             \
    && mv /etc/imapd.conf /etc/imapd.conf.d                       \
    && mv /etc/cyrus.conf /etc/cyrus.conf.d

ENV CYRUS_VERBOSE=1                                               \
    SASLAUTHD_SOCKETDIR=/run/saslauthd                            \
    SASLAUTHD_MECH=ldap                                           \
    SASLAUTHD_FLAGS=

EXPOSE 110 119 143 406 563 993 995 1109 2003 2004 2005 3905 4190
VOLUME /etc/imapd.conf.d /etc/cyrus.conf.d /etc/saslauthd.conf.d /run/saslauthd

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/libexec/cyrus-imapd/cyrus-master"]
