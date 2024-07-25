SRC_URI = "git://github.com/nxp-imx/linux-imx.git;protocol=https;branch=${SRCBRANCH}"
KBRANCH = "${SRCBRANCH}"
SRCBRANCH = "lf-6.6.y"
LOCALVERSION = "-lts-next"
SRCREV = "b586a521770e508d1d440ccb085c7696b9d6d387"
COMPATIBLE_MACHINE = "compulab-mx91"
KERNEL_CONFIG = "compulab-mx93_defconfig"

# Merged from the bbappend
# FILESEXTRAPATHS:prepend := "${THISDIR}/compulab/6.6.23/imx93:"

# require compulab/6.6.23/imx93.inc
