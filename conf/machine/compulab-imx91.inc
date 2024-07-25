MACHINEOVERRIDES =. "mx91:compulab-mx91:"

PREFERRED_PROVIDER_virtual/kernel:compulab-mx91 = "linux-compulab"
PREFERRED_PROVIDER_virtual/bootloader:compulab-mx91 = "u-boot-compulab"
PREFERRED_PROVIDER_linux-imx-mfgtool:compulab-mx91 = "linux-compulab-mfgtool"
PREFERRED_PROVIDER_linux-compulab-mfgtool:compulab-mx91 = "linux-compulab-mfgtool"

IMAGE_INSTALL:append = " \
	kernel-image \
	kernel-modules \
	kernel-devicetree \
"

PREFERRED_RROVIDER_u-boot-fw-utils = "libubootenv-bin"
