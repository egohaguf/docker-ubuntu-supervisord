FROM ubuntu:24.04

ENV DEBIAN_FRONTEND noninteractive
ENV TZ Asia/Tokyo

RUN sed -i -e 's%archive.ubuntu.com%ftp.udx.icscoe.jp/Linux%' -e 's%security.ubuntu.com%ftp.udx.icscoe.jp/Linux%' /etc/apt/sources.list.d/ubuntu.sources

RUN apt-get update \
        && apt-get -y upgrade \
        && apt-get -y install supervisor python3-venv python3-dev tzdata git vim-nox openssh-server tmux build-essential dbus \
        && echo "${TZ}" > /etc/timezone \
        && dpkg-reconfigure -f noninteractive tzdata

ADD supervisord.conf /etc/supervisor/supervisord.conf
ADD sshd.conf /etc/supervisor/conf.d/sshd.conf
ADD dbus.conf /etc/supervisor/conf.d/dbus.conf

RUN mkdir -p /var/run/sshd /var/run/dbus

CMD ["/usr/bin/supervisord", "-nc", "/etc/supervisor/supervisord.conf"]