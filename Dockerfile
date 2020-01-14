FROM centos:8
LABEL author "Fabio Montefuscolo <fabio.montefuscolo@gmail.com>"

ENV CYRUS_VERBOSE=1

RUN yum install -y                                                \
        cyrus-imapd                                               \
        cyrus-sasl                                                \
        cyrus-sasl-gs2                                            \
        cyrus-sasl-sql                                            \
        cyrus-sasl-ldap                                           \
        cyrus-sasl-scram                                          \
        cyrus-sasl-ntlm                                           \
        cyrus-imapd-utils                                         \
        cyrus-sasl-gssapi                                         \
        cyrus-sasl-plain                                          \
        cyrus-sasl-devel                                          \
        cyrus-sasl-lib                                            \
        cyrus-sasl-md5                                            \
        glibc-langpack-en                                         \
    && yum --enablerepo='*' clean all

EXPOSE 110 119 143 406 563 993 995 1109 2003 2004 2005 3905 4190

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/libexec/cyrus-imapd/cyrus-master"]
