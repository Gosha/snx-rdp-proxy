FROM ubuntu:bionic

WORKDIR /tmp

RUN dpkg --add-architecture i386 &&\
  apt-get -qq update && \
  apt-get -qq dist-upgrade

RUN apt-get install -y libpam0g:i386 \
  libx11-6:i386 \
  libstdc++6:i386 \
  libstdc++5:i386

RUN apt-get install -y python3-pip git net-tools sysstat
ENV TZ="Europe/Stockholm"
RUN DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true apt-get install -yq tzdata && \
  ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
  dpkg-reconfigure -f noninteractive tzdata

RUN echo "#/bin/sh\ntrue" >> /sbin/modprobe && chmod +x /sbin/modprobe


WORKDIR /workspace

ADD https://access.svea.com/SNX/INSTALL/snx_install.sh .
COPY root.db /etc/snx/root.db
RUN chmod +x ./snx_install.sh && ./snx_install.sh

WORKDIR /snxvpn
COPY snxvpn .
COPY snxvpnversion.py .
RUN pip3 install -e .

RUN apt-get install -y iptables iputils-ping curl iproute2
