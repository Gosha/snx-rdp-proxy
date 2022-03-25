FROM ubuntu:bionic

# Add support for :i386 packages
RUN dpkg --add-architecture i386 && apt-get -qq update

RUN apt-get install -y \
  # snxvpn gets installed with pip
  python3-pip \
  # snx dependencies
  libpam0g:i386 \
  libx11-6:i386 \
  libstdc++5:i386 \
  # Port forwarding
  socat \
  # Debug tools
  curl iproute2 iputils-ping net-tools

# snx tries to do `modprobe tun` during connection initialization
# Since this image should be run with --privileged that module is already loaded.
# So we just trick snx into thinking it loaded it.
RUN echo "#/bin/sh\ntrue" >> /sbin/modprobe && chmod +x /sbin/modprobe

WORKDIR /workspace

# Install snx
ADD https://access.svea.com/SNX/INSTALL/snx_install.sh .
RUN chmod +x ./snx_install.sh && ./snx_install.sh

# When connecting with snx to a server for the first time
# snx asks if you trust the certificate by showing an X dialog
# that displays a plain text fingerprint of the certificate.
# When pressing yes in that dialog, this file gets written.
# By supplying this file beforehand we can skip setting up X.
COPY root.db /etc/snx/root.db

# Install snxvpn (provides snxconnect)
WORKDIR /snxvpn
COPY snxvpn .
COPY snxvpnversion.py .
RUN pip3 install .

EXPOSE 3389

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

RUN apt-get install dante-server
ADD ./danted.conf /etc/danted.conf

CMD ["/entrypoint.sh"]
