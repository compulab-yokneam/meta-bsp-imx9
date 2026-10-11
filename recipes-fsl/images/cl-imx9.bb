# Copyright 2026 CompuLab Ltd.
# Released under the MIT license (see COPYING.MIT for the terms)

SUMMARY = "CompuLab i.MX9 evaluation and production-development image"

require recipes-fsl/images/imx-image-core.bb

# The vendor 6.18 kernel's perf sources currently do not build with this
# release's userspace tooling. Functional validation does not depend on perf.
IMAGE_FEATURES:remove = "tools-profile"

IMAGE_INSTALL:append = " \
    kernel-image \
    kernel-modules \
    kernel-devicetree \
    kernel-module-nxp-wlan \
    firmware-nxp-wifi-nxp-common \
    e2fsprogs-tune2fs \
    openssh \
    openssh-sshd \
    libnss-myhostname \
    cl-uboot \
    cl-deploy \
    serial-console-config \
    docker \
    nfs-utils \
    packagegroup-fsl-optee-imx \
    imx-ele-app \
    packagegroup-imx-ml \
    v4l-utils \
    media-ctl \
    gstreamer1.0 \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    cl-growfs-rootfs \
    libubootenv-bin u-boot-compulab-env \
    htop iotop tmux iperf3 \
    bluez5 eeprom-util usbutils \
    wpa-supplicant \
    networkmanager modemmanager \
"

export IMAGE_BASENAME = "cl-imx9"
