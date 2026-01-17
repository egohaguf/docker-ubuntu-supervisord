#!/bin/bash
set -e

# SSHホストキーが存在しない場合のみ再生成
if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
    dpkg-reconfigure openssh-server
fi

exec /usr/bin/supervisord -nc /etc/supervisor/supervisord.conf
