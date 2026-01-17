FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive
ENV TZ Asia/Tokyo

RUN apt-get update \
        && apt-get -y upgrade \
        && apt-get -y install supervisor python3-venv python3-dev tzdata git vim-nox openssh-server tmux \
        && echo "${TZ}" > /etc/timezone \
        && dpkg-reconfigure -f noninteractive tzdata

ADD supervisord.conf /etc/supervisor/supervisord.conf
ADD sshd.conf /etc/supervisor/conf.d/sshd.conf

RUN mkdir -p /var/run/sshd

CMD ["/usr/bin/supervisord", "-nc", "/etc/supervisor/supervisord.conf"]