LICENSE = "GPL-2.0-or-later"
LIC_FILES_CHKSUM = "file://Licenses/gpl-2.0.txt;md5=b234ee4d69f5fce4486a80fdaf4a4263"

SRCBRANCH = "lf_v2024.04"
SRC_URI = "git://github.com/nxp-imx/uboot-imx.git;protocol=https;branch=${SRCBRANCH}"
SRCREV = "674440bc73e1dd483b84269cccfad89ab40af424"
COMPATIBLE_MACHINE = "compulab-mx91"

# Merged from the bbappend
FILESEXTRAPATHS:prepend := "${THISDIR}/compulab/2024.04/imx91:"

require compulab/2024.04/imx91.inc

DEPENDS += " python3-setuptools-native "
