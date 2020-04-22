FROM centos:8
LABEL author "Fabio Montefuscolo <fabio.montefuscolo@gmail.com>"

RUN yum install -y                                                                       \
        cyrus-imapd                                                                      \
        cyrus-imapd-utils                                                                \
        cyrus-sasl                                                                       \
        cyrus-sasl-gs2                                                                   \
        cyrus-sasl-sql                                                                   \
        cyrus-sasl-ldap                                                                  \
        cyrus-sasl-scram                                                                 \
        cyrus-sasl-ntlm                                                                  \
        cyrus-sasl-gssapi                                                                \
        cyrus-sasl-plain                                                                 \
        cyrus-sasl-devel                                                                 \
        cyrus-sasl-lib                                                                   \
        cyrus-sasl-md5                                                                   \
        glibc-langpack-en                                                                \
        rsyslog                                                                          \
    && yum --enablerepo='*' clean all

RUN mkdir -p /etc/imapd.conf.d                                                           \
    && mkdir -p /etc/cyrus.conf.d                                                        \
    && mkdir -p /etc/saslauthd.conf.d                                                    \
    && mv /etc/imapd.conf /etc/imapd.conf.d                                              \
    && mv /etc/cyrus.conf /etc/cyrus.conf.d                                              \
    && {                                                                                 \
        echo '$WorkDirectory /var/lib/rsyslog';                                          \
        echo '$FileOwner root';                                                          \
        echo '$FileGroup adm';                                                           \
        echo '$FileCreateMode 0640';                                                     \
        echo '$DirCreateMode 0755';                                                      \
        echo '$Umask 0022';                                                              \
        echo 'include(file="/etc/rsyslog.d/*.conf" mode="optional")';                    \
        echo 'module(load="immark")';                                                    \
        echo 'module(load="imklog")';                                                    \
        echo '*.emerg :omusrmsg:*';                                                      \
    } > /etc/rsyslog.conf                                                                \
    && {                                                                                 \
        echo 'module(load="imtcp")';                                                     \
        echo 'input(type="imtcp" port="514")';                                           \
        echo 'module(load="imudp")';                                                     \
        echo 'input(type="imudp" port="514")';                                           \
        echo 'module(load="imuxsock")';                                                  \
        echo 'input(type="imuxsock" Socket="/run/rsyslog/dev/log" CreatePath="on")';     \
        echo '$ModLoad omstdout.so';                                                     \
        echo '*.* :omstdout:';                                                           \
    } > /etc/rsyslog.d/docker-cyrus.conf

EXPOSE 110 119 143 406 563 993 995 1109 2003 2004 2005 3905 4190
VOLUME /etc/imapd.conf.d /etc/cyrus.conf.d /etc/saslauthd.conf.d /run

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/libexec/cyrus-imapd/cyrus-master", "-M", "/etc/cyrus.conf", "-C", "/etc/imapd.conf"]
