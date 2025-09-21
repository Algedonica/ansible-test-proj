FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       openssh-server \
       sudo \
       ca-certificates \
       curl \
       gnupg \
       bash \
         systemd \
         python3 \
         python3-apt \
       locales \
    && rm -rf /var/lib/apt/lists/* \
    && locale-gen en_US.UTF-8

RUN mkdir /var/run/sshd \
    && echo 'PermitRootLogin no' >> /etc/ssh/sshd_config \
    && echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config \
    && useradd -ms /bin/bash devops \
    && echo 'devops:devops' | chpasswd \
    && usermod -aG sudo devops \
    && echo 'devops ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/90-devops

EXPOSE 22 80

CMD ["/usr/sbin/sshd","-D","-e"]
