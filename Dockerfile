FROM --platform=linux/arm/v7 rafa606/debian_arm_v7
WORKDIR /catkinws
ENV SSL_CERT_FILE=/usr/lib/ssl/certs/ca-certificates.crt
SHELL ["/bin/bash", "-c"]
RUN mkdir  /catkinws/src && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends -o \
                        Dpkg::Options::="--force-confnew" \
                        gnupg python3 python3-dev python3-pip build-essential \
                        libyaml-cpp-dev lsb-release isc-dhcp-server libnss-mdns \
                        avahi-daemon \
                        avahi-autoipd \
                        openssh-server \
                        isc-dhcp-client \
                        vim \
                        screen \
                        tmux \
                        netcat \
                        iproute2 \
                        libssl-dev freeglut3-dev libusb-1.0-0-dev pkg-config libgtk-3-dev unzip \
    && git clone https://github.com/IntelRealSense/librealsense.git /librealsense \
    && cp /librealsense/config/99-realsense-libusb.rules /etc/udev/rules.d/ \
    && mkdir /librealsense/build
RUN cd /librealsense/build && cmake .. -DFORCE_LIBUVC=true -DCMAKE_BUILD_TYPE=release && make -j3 && cpack -G DEB && ls
#sudo udevadm control --reload-rules && sudo udevadm trigger
