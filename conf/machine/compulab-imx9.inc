MACHINEOVERRIDES =. "mx93:compulab-mx93:"

PREFERRED_PROVIDER_virtual/kernel:compulab-mx93 = "linux-compulab"
PREFERRED_PROVIDER_virtual/bootloader:compulab-mx93 = "u-boot-compulab"
PREFERRED_PROVIDER_linux-imx-mfgtool:compulab-mx93 = "linux-compulab-mfgtool"
PREFERRED_PROVIDER_linux-compulab-mfgtool:compulab-mx93 = "linux-compulab-mfgtool"

CORE_IMAGE_EXTRA_INSTALL:append = " kernel-image kernel-modules \
    kernel-devicetree \
    kernel-module-nxp-wlan \
    firmware-nxp-wifi-nxp-common \
"

IMAGE_INSTALL:append = " python3-pytest "
IMAGE_INSTALL:append = " e2fsprogs-tune2fs openssh openssh-sshd "
IMAGE_INSTALL:append = " docker "
IMAGE_INSTALL:append = " nfs-utils "

PREFERRED_RROVIDER_u-boot-fw-utils = "libubootenv-bin"

CORE_IMAGE_EXTRA_INSTALL:append = " \
    ethos-u-firmware \
    linux-firmware-sd8997 \
    linux-firmware-iwlwifi-cc-a0 \
    linux-firmware-iwlwifi-ty-a0 \
    linux-firmware-ibt-20 \
    linux-firmware-ibt-41-41 \
"
