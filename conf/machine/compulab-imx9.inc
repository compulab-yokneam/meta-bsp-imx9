PREFERRED_PROVIDER_virtual/kernel:compulab-mx93 = "linux-compulab"
PREFERRED_PROVIDER_virtual/bootloader:compulab-mx93 = "u-boot-compulab"
PREFERRED_PROVIDER_linux-imx-mfgtool:compulab-mx93 = "linux-compulab-mfgtool"
PREFERRED_PROVIDER_linux-compulab-mfgtool:compulab-mx93 = "linux-compulab-mfgtool"

IMAGE_INSTALL:append = " \
	kernel-image \
	kernel-modules \
	kernel-devicetree \
"

PREFERRED_RROVIDER_u-boot-fw-utils = "libubootenv-bin"
