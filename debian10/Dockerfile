# Build with:
# docker buildx build --platform linux/amd64,linux/arm64 --push --tag rofrano/vagrant-provider:debian .
FROM debian:buster
LABEL MAINTAINERS="John Rofrano <rofrano@gmail.com>, Zack Lin <zacklin@kkstream.com>"

ENV DEBIAN_FRONTEND noninteractive

# install packages needed for ssh and development
RUN apt-get update \
    && apt-get -y install \
        locales man-db openssh-server passwd sudo \
        htop lsof strace file tree build-essential dnsutils curl wget multitail gettext \
        bash-completion tmux screen vim git git-crypt \
    && apt-get -qq clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# generate default locale
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen

# enable systemd (from Matthew Warman's mcwarman/vagrant-provider)
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*; \
    rm -f /etc/systemd/system/*.wants/*; \
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*; \
    rm -f /lib/systemd/system/anaconda.target.wants/*; \
    ln -s /lib/systemd/systemd /usr/sbin/init;

# enable ssh for vagrant
RUN systemctl enable ssh.service;
EXPOSE 22

# create the vagrant user
RUN useradd -m -G sudo -s /bin/bash vagrant \
    && echo "vagrant:vagrant" | chpasswd \
    && echo 'vagrant ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/vagrant \
    && chmod 440 /etc/sudoers.d/vagrant
ADD --chown=vagrant:vagrant skel/ /home/vagrant

# establish ssh keys for vagrant
RUN mkdir -p /home/vagrant/.ssh \
    && chmod 700 /home/vagrant/.ssh
ADD https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub /home/vagrant/.ssh/authorized_keys
RUN chmod 600 /home/vagrant/.ssh/authorized_keys \
    && chown -R vagrant:vagrant /home/vagrant/.ssh

# install additional packages
ARG GO_TARBALL=go1.17.linux-arm64.tar.gz
ADD https://golang.org/dl/${GO_TARBALL} /tmp
RUN rm -rf /usr/local/go && tar -C /usr/local -xzf /tmp/${GO_TARBALL}

# run the init daemon
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]
