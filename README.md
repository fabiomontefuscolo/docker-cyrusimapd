# Cyrus Container

This image contains Cyrus pieces to run a IMAP server with logging and saslauthd integration. As these 3 things are 3 different services, it is needed to run this image as 3 different containers, each on running a different command.
It is desireble to run in this order:

1. rsyslog container
2. saslauthd container
3. cyrus master container

Cyrus IMAP, Saslauthd and Rsyslogd talk to each other through unix sockets placed on `/run` folder. So the containers needs to share this folder between them.

The following `docker-compose.yml` piece were used while creating this image:

```yml
version: '2'
services:
  cyrus-master:
    image: montefuscolo/cyrus-imapd
    volumes_from:
      - cyrus-rsyslog
      - cyrus-saslauthd
    depends_on:
      - cyrus-rsyslog
      - cyrus-saslauthd
    command: /usr/libexec/cyrus-imapd/cyrus-master

  cyrus-saslauthd:
    image: montefuscolo/cyrus-imapd
    tty: true
    stdin_open: true
    volumes_from:
      - cyrus-rsyslog
    depends_on:
      - cyrus-rsyslog
    command: /usr/sbin/saslauthd -V -d -m /run/saslauthd -a ldap

  cyrus-rsyslog:
    image: montefuscolo/cyrus-imapd
    command: rsyslogd -n -f /etc/rsyslog.conf -i /run/rsyslogd.pid
```