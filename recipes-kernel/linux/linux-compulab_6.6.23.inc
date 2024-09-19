LICENSE = "GPL-2.0-or-later"
SRCBRANCH = "linux-compulab_v6.6.23"
SRC_URI = "git://github.com/compulab-yokneam/linux-compulab;protocol=https;branch=${SRCBRANCH}"
SRCREV = "${AUTOREV}"
LINUX_VERSION = "6.6.23"
LOCALVERSION = "-lts-next"
KERNEL_CONFIG = "compulab-mx93_defconfig"

