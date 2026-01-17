FROM ubuntu:24.04

ENV DEBIAN_FRONTEND noninteractive
ENV TZ Asia/Tokyo

RUN sed -i -e 's%archive.ubuntu.com%ftp.udx.icscoe.jp/Linux%' -e 's%security.ubuntu.com%ftp.udx.icscoe.jp/Linux%' /etc/apt/sources.list.d/ubuntu.sources

RUN apt-get update \
        && apt-get -y upgrade \
        && apt-get -y install supervisor python3-venv python3-dev tzdata git vim-nox openssh-server tmux build-essential dbus curl lsb-release \
        && echo "${TZ}" > /etc/timezone \
        && dpkg-reconfigure -f noninteractive tzdata

RUN mkdir -p --mode=0755 /usr/share/keyrings \
        && curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null \
        && echo "deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/cloudflared.list \
        && apt-get update \
        && apt-get install -y cloudflared

ADD supervisord.conf /etc/supervisor/supervisord.conf
ADD sshd.conf /etc/supervisor/conf.d/sshd.conf
ADD dbus.conf /etc/supervisor/conf.d/dbus.conf
ADD cloudflared.conf /etc/supervisor/conf.d/cloudflared.conf

RUN mkdir -p /var/run/sshd /var/run/dbus

CMD ["/usr/bin/supervisord", "-nc", "/etc/supervisor/supervisord.conf"]